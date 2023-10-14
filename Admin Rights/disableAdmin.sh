
#!/bin/bash
####################################################################################
# This is the removal script for the enableAdmin.sh script. It will remove the user from
# the admin group and will disable the plist that calls this script. 
# Create a Jamf policy with this script and a trigger of "disableAdmin"
####################################################################################

if [[ -f /var/adminLogs/userToRemove ]]; then
	User=`cat /var/adminLogs/userToRemove`
	echo "removing" $User "from admin group"
	/usr/sbin/dseditgroup -o edit -d $User -t user admin
	echo $User "has been removed from admin group"
	rm -f /var/adminLogs/userToRemove
    echo $TIME "Admin rights disabled for" $User >> /var/adminLogs/60minAdmin.txt
else
	defaults write /Library/LaunchDaemons/com.admin.disableAdmin.plist disabled -bool true
	echo "going to unload"
	launchctl unload -w /Library/LaunchDaemons/com.admin.disableAdmin.plist
	echo "Completed"
	rm -f /Library/LaunchDaemons/com.admin.disableAdmin.plist
fi

exit 0