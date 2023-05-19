#!/bin/bash

scutil_query()
{
    key=$1

    scutil<<EOT
    open
    get $key
    d.show
    close
EOT
}

INTERFACE_NAME=`scutil_query State:/Network/Global/IPv4 | grep "PrimaryInterface" | awk '{print $3}'`
IP=`ifconfig $INTERFACE_NAME | grep inet | cut -d" " -f 2 | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -v 127.0.0.1 | head -1`

echo $IP
