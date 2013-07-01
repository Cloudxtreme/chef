#!/bin/bash

# this script lives at $repo/install/chef.sh

export PATH=/usr/local/sbin:/usr/sbin:/sbin:$PATH

dir=$(readlink -f `dirname $0`)
tmpdir=$dir/tmp
clientrepo=http://chef.localdomain
serverrepo=https://chef.example.com
repo=
RUBY_VER="enterprise-1.8.7-2010.01"
OHAI_VER=0.6.8
CHEF_VER=0.10.4
NGINX_VER=1.0.15
JSONPY_VER="3_4"
DEL_PKGS="dovecot httpd-server-status httpd mysql mysql-server vsftpd php php-common php-cli php-pdo php-mysql php-xml php-imap php-gd php-mbstring php-pear"
INSTALL_PKGS="gcc gcc-c++ curl openssl openssl-devel subversion python python-devel libstdc++-devel wget readline readline-devel pcre pcre-devel"
DEB_PKGS="gcc curl openssl subversion python python-dev libstdc++6-4.4-dev wget libreadline5 libreadline-dev libpcre3 libpcre3-dev zlib1g-dev libssl-dev"
PREFIX_DIR=/usr/local
GCE_DIR=/mnt/scratch0

locations() {
    echo -e "\nlocations:"
    echo "
    dc1 => prod dc
    dc2 => dev dc
    gdc3 => gce dc
    "
}

create_chef_dir() {
    [ ! -d /etc/chef ] && mkdir -m 700 /etc/chef 
}

disable_selinux() {
    [ -f /selinux/enforce ] && echo 0 > /selinux/enforce 
    [ -f /etc/selinux/config ] && sed -i 's@SELINUX=\(enforcing\|permissive\)@SELINUX=disabled@g' /etc/selinux/config
}

get() {
    wget -q -O $1 $repo/archive/$1 --no-check-certificate
}

get_chef_archive() {
    local archive_dir=/usr/local/nginx/html/chef-solo/archive

    # Get the list of packages to transfer.
    wget -q -O /tmp/chef.resource.list $repo/archive/resource.list --no-check-certificate
 
    # Get the excluded list of packages if there is one.
    wget -q -O /tmp/chef.exclude.list $repo/archive/$location.exclude.list --no-check-certificate

    # If there is currently no resource list or the md5sum comparison mismatch
    # then there are packages to be transferred.
    if [ ! -f "$archive_dir/resource.list" ] || [ "$(md5sum /tmp/chef.resource.list)" != "$(md5sum $archive_dir/resource.list)" ]; then
	for pkg in `cat /tmp/chef.resource.list`; do 
            # If the package is not excluded and doesn't exist then download it.
	    if ! $(egrep -q "^$pkg$" /tmp/chef.exclude.list) && [ ! -f "$archive_dir/$pkg" ]; then
		wget -q -O "$archive_dir/$pkg" "$repo/archive/$pkg" --no-check-certificate                
	    fi
	done
        mv /tmp/chef.resource.list $archive_dir/resource.list
    fi

    rm -f /tmp/chef.resource.list
}

install_chef_client() {
    for dir in /usr/local/chef/backups /usr/local/chef/logs ; do
	[ ! -d $dir ] && mkdir -m 700 -p $dir
    done
    
    wget -q -O /etc/init.d/.chef-client $repo/install/chef-client.sh --no-check-certificate
    if [ $? -eq 0 ]; then
	mv /etc/init.d/.chef-client /etc/init.d/chef-client && chmod 700 /etc/init.d/chef-client
    else
	echo "error: chef client update failed" && rm -f /etc/init.d/.chef-client && exit 1
    fi
}

install_chef_gem() {
    if ! $(gem source --list | grep -q "http://gems.opscode.com"); then
        gem source -a http://gems.opscode.com
    fi

    [ $(gem list -i ohai -v $OHAI_VER) == "false" ] && gem install ohai -v=$OHAI_VER --no-rdoc --no-ri
    [ $(gem list -i chef -v $CHEF_VER) == "false" ] && gem install chef -v=$CHEF_VER --no-rdoc --no-ri
}

install_chef_nginx() {
    [ ! -d $tmpdir ] && mkdir $tmpdir

    if [ ! -d /usr/local/nginx ]; then
	pushd $tmpdir >/dev/null
	get nginx-$NGINX_VER.tar.gz && tar zxf nginx-$NGINX_VER.tar.gz
	if [ -d nginx-$NGINX_VER ]; then 
	    pushd nginx-$NGINX_VER >/dev/null
	    ./configure --with-http_ssl_module --with-http_stub_status_module --prefix=$PREFIX_DIR/nginx-$NGINX_VER
	    make && make install && ln -s $PREFIX_DIR/nginx-$NGINX_VER /usr/local/nginx
	    popd >/dev/null
	    rm -rf nginx-$NGINX_VER
	else
	    echo "nginx-$NGINX_VER does not exist"
	    exit 1
	fi
	popd >/dev/null
    else
	echo "nginx is already installed"
    fi

    [ -d $tmpdir ] && rm -rf $tmpdir
}

install_chef_server() {
    local html_dir=/usr/local/nginx/html
    local get_tarball=false

    if [ ! -f $html_dir/chef-solo/chef.tar.gz ]; then
	get_tarball=true
    else
      local local_md5=$(md5sum $html_dir/chef-solo/chef.tar.gz | awk '{print $1}')
      local remote_md5=$(wget -q -O - $repo/chef.tar.gz.md5 --no-check-certificate)
      
      [ "$remote_md5" != "$local_md5" ] && get_tarball=true
    fi

    if [ $get_tarball == true ]; then
        wget -q -O chef.tar.gz $repo/chef.tar.gz --no-check-certificate && \
	rm -rf cs-tmp && mkdir cs-tmp && tar zxf chef.tar.gz -C cs-tmp/ && \
	mv chef.tar.gz cs-tmp/chef-solo/ && rsync -az --exclude='archive/*' --delete cs-tmp/chef-solo/ $html_dir/chef-solo/ && \
	rm -rf cs-tmp
    fi
}

install_deb_packages() {
    for command in "install debian-archive-keyring -q -y" "clean -q" \
	"update -q --fix-missing" "install -q -y $DEB_PKGS" "install -q -y build-essential"
    do
	apt-get $command
	if [ $? -ne 0 ]; then
            sleep $(($RANDOM % 10))
	    install_deb_packages
	fi
    done
}

install_dependencies() {
    install_packages
    install_ruby
    install_json
}

install_json() {
    # Install python json
    if [ $(find /usr/lib/python* -name "json.py"|wc -l) -eq 0 ]; then
	mkdir json-tmp
	pushd json-tmp >/dev/null
	get json-py-$JSONPY_VER.zip && unzip json-py-"$JSONPY_VER".zip
	
	if [ -f json.py ]; then
	    for j in /usr/lib/python*; do
		[ -d "$j/site-packages" ] && [ ! -f "$j/site-packages/json.py" ] && cp json.py $j/site-packages/json.py
	    done
	else
	    echo "json.py does not exist"
	    exit 1
	fi
	
	popd >/dev/null
	rm -rf json-tmp
    fi
}

install_nginx_conf() {
    echo "install nginx.conf"
    if ! $(grep -q "vhosts/" /usr/local/nginx/conf/nginx.conf); then
        wget -q -O /usr/local/nginx/conf/nginx.conf $repo/install/server/nginx.conf --no-check-certificate
    fi

    if [ -f /usr/local/nginx/logs/nginx.pid ] && [ -n "$(cat /usr/local/nginx/logs/nginx.pid)" ]; then
	/etc/init.d/nginx reload
    else
        /etc/init.d/nginx start
    fi
}

install_nginx_initd() {
    echo "install nginx init.d"
    if [ -f /etc/debian_version ]; then
	wget -q -O /etc/init.d/nginx $repo/install/server/ubuntu.nginx --no-check-certificate
    elif [ -f /etc/redhat-release ]; then
	wget -q -O /etc/init.d/nginx $repo/install/server/centos.nginx --no-check-certificate
    fi	
    
    chmod 755 /etc/init.d/nginx
}

install_packages() { 
    if [ -f /etc/debian_version ]; then
	install_deb_packages
    elif [ -f /etc/redhat-release ]; then
	install_yum_packages
    fi
}

install_ruby() {
   [ ! -d $tmpdir ] && mkdir $tmpdir

    if [ ! -d "/usr/local/ruby" ]; then
	RUBY_SRC=ruby-$RUBY_VER
	
	get $RUBY_SRC.tar.gz && tar zxf $RUBY_SRC.tar.gz
	if [ -d $RUBY_SRC ]; then
	    pushd $RUBY_SRC >/dev/null
	    ./installer --auto=/usr/local/$RUBY_SRC
	    
	    if [ $? -eq 0 ]; then
		if [ ! -L /usr/local/ruby ] && [ ! -d /usr/local/ruby ]; then
		    ln -s /usr/local/$RUBY_SRC /usr/local/ruby
		fi
		export PATH=/usr/local/ruby/bin:$PATH
		gem install rubygems-update
		gem update --system
	    fi

	    popd >/dev/null
	    rm -rf $RUBY_SRC
	else
	    echo "$RUBY_SRC does not exist"
	    exit 1
	fi
    fi

    export PATH=/usr/local/ruby/bin:/usr/sbin:$PATH

    [ -d $tmpdir ] && rm -rf $tmpdir
}

install_server_host() {
    if ! $(egrep -q "^(10(\.[0-9]{1,3}){3}|192\.168(\.[0-9]{1,3}){2}|172\.1[6-8](\.[0-9]{1,3}){2})\b.+\bchef.localdomain\b" /etc/hosts); then
	local ip=$(/sbin/ifconfig  | egrep "inet addr:(10(\.[0-9]{1,3}){3}|192\.168(\.[0-9]{1,3}){2}|172\.1[6-8](\.[0-9]{1,3}){2})" | head -1 | cut -d : -f 2 | awk '{print $1}')
	echo "$ip chef.localdomain" >> /etc/hosts
    fi
}

install_server_keys() {	
    if [ ! -f /usr/local/nginx/conf/server.key ] && [ ! -f /usr/local/nginx/conf/server.cert ]; then
	echo "generate server keys"
	openssl genrsa -des3 -passout pass:example -out /usr/local/nginx/conf/server.key.orig 2048
	openssl rsa -passin pass:example -in /usr/local/nginx/conf/server.key.orig -out /usr/local/nginx/conf/server.key
	openssl req -new -subj '/CN=chef.localdomain/O=Example.com Ltd/C=GB/ST=London/L=London' \
		-key /usr/local/nginx/conf/server.key -out server.csr
	openssl x509 -req -days 365 -in server.csr -signkey /usr/local/nginx/conf/server.key -out /usr/local/nginx/conf/server.crt
	rm -f server.csr
    fi
}

install_yum_packages() {
    # Install packages
    for package in $DEL_PKGS; do
	if $(rpm -qa | grep -q $package); then
	    yum remove -y $package
	fi
    done

    yum install -q -y $INSTALL_PKGS
    yum groupinstall -q -y "development tools"
}

set_location() {
    [ -z "$1" ] && echo "error: location is empty" && exit 1
    echo "$1" > /etc/chef/location
}

set_prefix_dir() {
    [ -z "$1" ] && return 1

    if $(echo "$1"|egrep -q "^gdc[0-9]?$"); then
        PREFIX_DIR=$GCE_DIR
    fi
}

usage() {
    echo "usage: $0 {install|update} {client|server} [location]" && locations
}

# main functions

install() {
    disable_selinux

    case "$1" in
	client)
	    repo=$clientrepo
	    install_dependencies
	    install_chef_gem
	    install_chef_client
	    ;;
	server)
	    echo "are you sure you want to install a chef server: yes or no?"
	    read answer
	    [ "$answer" != "yes" ] && exit
	    repo=$serverrepo
	    install_server_host
	    install_dependencies
	    install_chef_gem
	    install_chef_nginx
	    install_chef_server
	    install_server_keys	
	    get_chef_archive
	    install_nginx_initd
	    install_nginx_conf    
	    ;;		
    esac	
}

update() {
    case "$1" in
	client)
            repo=$clientrepo
	    install_chef_client
	;;
	server)
            echo "are you sure you want to update the chef server: yes or no?"
            read answer && [ "$answer" == "no" ] && exit
            repo=$serverrepo
	    install_chef_server
	    get_chef_archive
	    install_nginx_initd
	    install_nginx_conf
	;;
    esac
}

# parse command line args

while [ $# -gt 0 ]; do
    case "$1" in
	install|update)
	procedure=$1	
	;;
	client|server)
	type=$1
	;;
	dc[0-9]|gdc[0-9])
	location=$1
	;;
	*)
	usage
	exit 1
    esac
    shift
done

# check for null values
[ -z "$procedure" ] || [ -z "$type" ] || [ -z "$location" ] && usage && exit 1

# create chef dir and set location
create_chef_dir
set_location $location
set_prefix_dir $location

# execute install/update
$procedure $type

exit $?
