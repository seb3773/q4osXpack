#!/bin/bash
find /var/log -type f -name "*.log" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.1" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.2" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.3" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.4" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.5" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.6" -exec tee {} \; </dev/null
find /var/log -type f -name "*.log.old" -exec tee {} \; </dev/null
cat /dev/null >/var/log/syslog > /dev/null 2>&1
cat /dev/null >/var/log/syslog.1 > /dev/null 2>&1
cat /dev/null >/var/log/wtmp > /dev/null 2>&1
cat /dev/null >/var/log/wtmp.1 > /dev/null 2>&1
cat /dev/null >/var/log/dpkg.log > /dev/null 2>&1
cat /dev/null >/var/log/user.log > /dev/null 2>&1
cat /dev/null >/var/log/kern.log > /dev/null 2>&1
cat /dev/null >/var/log/auth.log > /dev/null 2>&1
cat /dev/null >/var/log/alternatives.log > /dev/null 2>&1
cat /dev/null >/var/log/fontconfig.log > /dev/null 2>&1
cat /dev/null >/var/log/cron.log > /dev/null 2>&1
cat /dev/null >/var/log/anydesk.trace > /dev/null 2>&1
rm -v /var/log/*.gz > /dev/null 2>&1
