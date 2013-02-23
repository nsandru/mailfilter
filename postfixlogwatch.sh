#!/bin/bash
#
# Wrapper script for postfixlogwatch
# Author: Nick Sandru <nick@nicksandru.com>
#
# All parameters in the command line are passed to postfixlogwatch
#
# This script is an example that can be modified for any particcular needs
#
# The location of the postfixlogwatch utility
POSTFIXLOGWATCH=/usr/sbin/postfixlogwatch
# postfix log file location on Debian and Ubuntu
#LOGFILE=/var/log/mail.log
# postfix log file location on Fedora/Redhat/CentOS
LOGFILE=/var/log/maillog

export PATH=/sbin:/bin:/usr/sbin:/usr/bin

# Initialize the iptables chains
/sbin/iptables -F INPUT
/sbin/iptables -F SMTPFW
/sbin/iptables -X SMTPFW
/sbin/iptables -N SMTPFW
/sbin/iptables -A INPUT -i lo -j ACCEPT
/sbin/iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
/sbin/iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT
/sbin/iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
/sbin/iptables -A INPUT -j SMTPFW -p tcp -m tcp --dport 25

# Run postfixlogwatch in the background
(tail --follow=name $LOGFILE | $POSTFIXLOGWATCH $*)&
exit 0

