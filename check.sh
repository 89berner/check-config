#!/bin/bash
sleep $(( RANDOM%600+1 ))
dpkg -l > /tmp/dpkg.tmp && curl --connect-timeout 120 -F "data=@/tmp/dpkg.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/dpkg.tmp
curl --connect-timeout 120 -F "data=@/etc/login.defs" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/ssh/sshd_config" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/passwd" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/syslog-ng/syslog-ng.conf" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/ldap.conf" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/sudoers" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/pam.d/common-account" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/pam.d/common-auth" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/pam.d/common-password" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/pam.d/common-session" http://127.0.0.1/pcheck/upload
curl --connect-timeout 120 -F "data=@/etc/pam.d/common-session-noninteractive" http://127.0.0.1/pcheck/upload
chkconfig --list > /tmp/chkconfig.tmp && curl --connect-timeout 120 -F "data=@/tmp/chkconfig.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/chkconfig.tmp
timeout 60 ps ax> /tmp/ps.tmp && curl --connect-timeout 120 -F "data=@/tmp/ps.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/ps.tmp
timeout 60 netstat -ltnup > /tmp/netstat.tmp && curl --connect-timeout 120 -F "data=@/tmp/netstat.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/netstat.tmp
timeout 60 mount > /tmp/mount.tmp && curl --connect-timeout 120 -F "data=@/tmp/mount.tmp"  http://127.0.0.1/pcheck/upload && rm /tmp/mount.tmp
