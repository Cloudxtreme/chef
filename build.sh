#!/bin/bash

homedir=$(dirname `readlink -f $0`)
webdir=/var/www/html/chef-solo

build_tarball() {
    echo "build tarballs"
    tar zcf chef-solo/cookbooks.tar.gz --exclude-vcs cookbooks
    tar zcf chef-solo/chef.tar.gz --exclude-vcs chef-solo/*
}

create_roles() {
    echo "create roles"
    dir=$homedir/chef-solo/install/client

    for j in `find $dir -maxdepth 1 -type d -not -name "\.svn" |grep -v "^$dir$"`; do
	ls $j/*.chef.json 2> /dev/null | sed "s@$j/\(.\+\)\.chef\.json\$@\1@g" > $j/roles.txt; 
    done
}

md5_tarball() {
    echo "md5 tarballs"
    md5sum chef-solo/cookbooks.tar.gz |awk '{print $1}' > chef-solo/cookbooks.tar.gz.md5
    md5sum chef-solo/chef.tar.gz |awk '{print $1}' > chef-solo/chef.tar.gz.md5
}

metadata() {
    echo "knife cookbook metadata --all"
    knife cookbook metadata --all
}

set_ruby() {
    if [ -f /usr/local/rvm/scripts/rvm ]; then
        local rvm_script=/usr/local/rvm/scripts/rvm
    elif [ -f $HOME/.rvm/scripts/rvm ]; then
        local rvm_script=/usr/local/rvm/scripts/rvm
    fi

    if [ -n "$rvm_script" ]; then
	echo "using rvm"
	source $rvm_script
	rvm 1.9.2@chef
    fi
}

sync_configs() {
    echo "sync configs"
    rsync -avz --exclude=\.svn --exclude=archive/* --delete chef-solo/ $webdir/ 
}

test_json() {
    echo "test json files"
    for file in $(find chef-solo/install/client -name "*.json"); do
	ruby -e "require 'json'; file = File.read(\"$homedir/$file\"); JSON.parse(file);" &>/dev/null
	if [ $? -ne 0 ]; then
	    echo "error: failed to parse $file"
	    exit 1
	fi
    done
}

test_syntax() {
    echo "knife cookbook test -all"
    knife cookbook test --all
    [ $? -eq 1 ] && echo "rake test failed" && exit 1
}

all() {
    metadata
    test_json
    test_syntax
    create_roles
    build_tarball
    md5_tarball
    sync_configs
}

a_local() {
    metadata
    test_json
    test_syntax
    create_roles
    build_tarball
    md5_tarball
}

usage() {
    echo "usage: $0 [all|build_tarball|metadata|sync_configs|test_json|test_syntax]"
}

pushd $homedir >/dev/null

[ "$1" != "usage" ] && set_ruby

case "$1" in
    create_roles)
	create_roles
	;;
    build_tarball)
	build_tarball
	md5_tarball
	;;
    metadata)
	metadata
	;;
    sync_configs)
	sync_configs
	;;
    test_json)
	test_json
	;;
    test_syntax)
	test_syntax
	;;
    usage)
	usage
	exit
	;;
    all|*)
	all
	;;
esac

popd >/dev/null

exit $?
