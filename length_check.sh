#!/bin/bash

#检测字符串及长度的函数
length_check()
{
#length_string
#$1=string, $2=length of string not to exceed this number
_STR=$1
_MAX=$2
_LENGTH=`echo $_STR |awk '{ print length($0)}'`
if [ "$_LENGTH" -gt "$_MAX" ]; then
	return 1
else
	return 0
fi
}

#检测字符串是否为数字
a_number()
{
#a_number
#$1=string
_NUM=$1
_NUM=`echo $1|awk '{if($0~/[^0-9]/) print "1"}'`
if [ "$_NUM" != "" ];then
	return 1
else
	return 0
fi
}

#检测字符串是否为字符型
characters()
#charecters
# $1 = string
{
_LETTERS_ONLY=$1
_LETTERS_ONLY=`echo $1|awk '{if($0~/[^a-zA-Z]/) print "1"}'`

if [ "$_LETTERS_ONLY" != "" ];then
	return 1
else
	return 0
fi
}

