#!/bin/bash
#
# Wrapper script for cyruslogwatch
# Author: Nick Sandru <nick@nicksandru.com>
#
# All parameters in the command line are passed to postfixlogwatch
#
# This script is an example that can be modified for any particcular needs
#
# The location of the postfixlogwatch utility
CYRUSLOGWATCH=/usr/sbin/cyruslogwatch
# cyrus log file location on Debian and Ubuntu
LOGFILE=/var/log/mail.log
# cyrus log file location on Fedora/Redhat/CentOS
#LOGFILE=/var/log/maillog

export PATH=/sbin:/bin:/usr/sbin:/usr/bin
CKPDIR=/var/lib/cyruslogwatch
CYRUSFW=CYRUSFW

for ARG in $* ; do
  ARGN=`echo $ARG | cut -f1 -d=`
  ARGV=`echo $ARG | cut -f2 -d=`
  case $ARGN in
  --checkpoint)
    CKPDIR=`dirname $ARGV`
    test -d $CKPDIR || mkdir -p $CKPDIR
    ;;
  --firewall)
    SMTPFW=$ARGV
    ;;
  *)
    ;;
  esac
done
# Initialize the iptables chains
/sbin/iptables -F INPUT
/sbin/iptables -F $CYRUSFW
/sbin/iptables -X $CYRUSFW
/sbin/iptables -N $CYRUSFW
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
/sbin/iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
for PORT in 110 143 993 995 ; do
/sbin/iptables -A INPUT -j $CYRUSFW -p tcp -m tcp --dport $PORT
done

# Run postfixlogwatch in the background
(tail --follow=name $LOGFILE | $CYRUSLOGWATCH $*)&
exit 0

