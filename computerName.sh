#!/bin/sh
# This script changes the name of a computer to its serial number with a prefix 
# example: MSTUDIO-SERIAL#
#
# Change this variable to whatever prefix you want to use.
siteCode='NAMEPREFIX-'
#
##############################################################################
serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
computerName=$siteCode$serial

/usr/sbin/scutil --set ComputerName "${computerName}"
/usr/sbin/scutil --set LocalHostName "${computerName}"
/usr/sbin/scutil --set HostName "${computerName}"

dscacheutil -flushcache

echo "Computer name has been set..."
echo "<result>`scutil --get ComputerName`</result>"
echo $computerName

exit 0