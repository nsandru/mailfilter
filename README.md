mailfilter
==========

# Utilities for email filtering

```
  postfixlogwatch - protects a postfix server against abusive SMTP connections
  amavislogwatch  - blocks connections from sources of spam and malware detected by Amavis
  cyruslogwatch   - protects a cyrus IMAP/POP3 server against brute force crack attempts
```

All utilities are distributed under GPLv3 license

## Usage:

- copy the utility to /usr/sbin or /usr/local/sbin
- edit the wrapper script and update the paths for the log file and utility
- run the wrapper script with the desired arguments for the utility

## Usage with rsyslog:

Add the following scripts in /etc/rsyslog.d:

/etc/rsyslog.d/postfix.conf:

```
# Create an additional socket in postfix's chroot in order not to break
# mail logging when rsyslog is restarted.  If the directory is missing,
# rsyslog will silently skip creating the socket.
$AddUnixListenSocket /var/spool/postfix/dev/log
```

/etc/rsyslog.d/postfixlogwatch.conf:

```
module(load="omprog")
if $syslogfacility-text == 'mail' then action(type="omprog" binary="/usr/local/sbin/postfixlogwatch_run" template="RSYSLOG_TraditionalFileFormat")
if $syslogfacility-text == 'mail' then action(type="omprog" binary="/usr/local/sbin/amavislogwatch_run" template="RSYSLOG_TraditionalFileFormat")
if $syslogfacility-text == 'mail' then action(type="omprog" binary="/usr/local/sbin/cyruslogwatch_run" template="RSYSLOG_TraditionalFileFormat")
```

--
Nick Sandru
