#!/bin/bash

role=$1
repo=chef.localdomain
chefdir=/etc/chef
PATH=/usr/local/ruby/bin:$PATH

[ ! -d $chefdir ] && echo "please install chef client: wget -O ~/chef.sh http://$repo/install/chef.sh" && exit 1

[ -f $chefdir/location ] && location=$(cat $chefdir/location)

get_roles() {
    [ -z "$location" ] && local location=default

    wget -q -O $chefdir/roles.txt  http://$repo/install/client/$location/roles.txt
    if [ $? -eq 0 ] && [ -s $chefdir/roles.txt ]; then
	return 0        
    else
	return 1
    fi	
}

check_role() {
    get_roles

    if [ $? -eq 0 ]; then
        if [ -z "$1" ]||[ ! $(grep "^$1$" $chefdir/roles.txt) ]; then
            return 1
        fi
    else
        return 1
    fi
}

get_solo_rb() {
    wget -q -O $chefdir/solo.rb http://$repo/install/client/solo.rb
    if [ $? -eq 0 ]; then
	return 0
    else	
	return 1
    fi
}

set_node() {
    [ -z "$1" ] && return 1

    if [ -f $chefdir/node ]; then
	local node=$(cat $chefdir/node)
        if [ "$1" != "$node" ]; then
	    echo "Server node type is $node. rm -f $chefdir/node if you want to change it"
	    exit 1
	fi
    else
	echo "$1" > $chefdir/node
    fi
}

usage() {
    echo "usage: $0 [role]"
    echo
    echo "roles:"

    if [ -s $chefdir/roles.txt ]; then
        cat $chefdir/roles.txt
    else
	echo "no roles available"
    fi
}

check_role $role

if [ $? -eq 0 ]; then
    set_node $role
    get_solo_rb
    CHEF_ROLE=$role CHEF_LOCATION=$location chef-solo

    exit $?
else
    usage
    exit 1
fi
