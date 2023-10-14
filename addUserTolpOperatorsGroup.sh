#!/bin/bash
# This script corrects issues where users can not unpause the print queue by adding
# them to the lpOperators Group
# Get current logged on user
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
#Add user to lpOperator Group
if [ $lastUser = "loginwindow" ]; then
exit 0
else
dseditgroup -o edit -a $lastUser -t user _lpoperator
exit 0
fi
