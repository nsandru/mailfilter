mailfilter
==========

Utilities for email filtering

- postfixlogwatch     -protects a postfix server against abusive SMTP connections
- cyruslogwatch       -protects a cyrus IMAP/POP3 server against brute force crack attempts

All utilities are distributed under GPLv3 license

Usage:

- copy the utility to /usr/sbin or /usr/local/sbin
- edit the wrapper script and update the paths for the log file and utility
- run the wrapper script with the desired arguments for the utility

Nick Sandru
