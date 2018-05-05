#!/bin/bash
#writer:qiulibo 7/11/17


DIR=$1
List=$(find $DIR -name *test.txt)

for i in $List
do
	sed -i 's/workid=0/workid=1/' $i
	echo "$i was replace!"
done
