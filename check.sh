#!/bin/bash
sleep $(( RANDOM%600+1 ))
dpkg -l > /tmp/dpkg.tmp && curl --connect-timeout 120 -F "data=@/tmp/dpkg.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/dpkg.tmp
curl --connect-timeout 120 -F "data=@/etc/sudoers" http://127.0.0.1/pcheck/upload
chkconfig --list > /tmp/chkconfig.tmp && curl --connect-timeout 120 -F "data=@/tmp/chkconfig.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/chkconfig.tmp

