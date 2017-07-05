#!/bin/bash

HOST=192.168.18.22
USER=root
PASS=')iBOK%e0QVtAT8'

QUERY=`mysql -h$HOST -u$USER -p$PASS <<EOF
    use vpn;
    select * from vpnuser;
    exit
    EOF`
echo $QUERY
