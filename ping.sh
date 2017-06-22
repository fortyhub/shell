#!/bin/bash

for i in {1..254}
do
    ping -c1 192.168.18.$i &>/dev/null
    if [ $? -eq 0 ]; then
	echo 192.168.18.$i >> ip.txt
        echo "192.168.18.$i is use"
    else
        echo "192.168.18.$i not use"
        continue
    fi
done
