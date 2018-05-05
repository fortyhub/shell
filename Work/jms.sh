#!/usr/bin/expect

#set timeout
set timeout 10

#spawn ssh -i /Users/qiulibo/Desktop/wuyou/keys/qiulibo.pem qiulibo@192.168.18.207
spawn ssh -p 2222 qiulibo@47.97.37.151
#expect "*passphrase*"

#send "IOqkXJw5vciXk0mt\r"
#send ""
#send ""

#allow user interaction
interact
