#!/bin/bash
##################################################################################################
# This script will give the logged on user 60 minutes of Admin level access, from Jamf's Self Service.
# At the end of the 60 minutes it will then call a jamf policy with the "disableAdmin" trigger
# with the disableAdmin script as the payload. This will remove the users admin rights and 
# delete the plist file this creates.
##################################################################################################

User=`who |grep console| awk '{print $1}'`

# Message to user they have admin rights for 60 min. 
/usr/bin/osascript <<-EOF
			    tell application "System Events"
			        activate
			        display dialog "Admin rights will be granted to $User for 60 minutes" buttons {"Do It"} default button 1
			    end tell
			EOF

# Place launchD plist to call JSS policy to remove admin rights.
echo "<?xml version="1.0" encoding="UTF-8"?> 
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"> 
<plist version="1.0"> 
<dict>
	<key>Disabled</key>
	<true/>
	<key>Label</key> 
	<string>com.admin.disableAdmin</string> 
	<key>ProgramArguments</key> 
	<array> 
		<string>/usr/local/bin/jamf</string>
		<string>policy</string>
		<string>-trigger</string>
		<string>disableAdmin</string>
	</array>
	<key>StartInterval</key>
	<integer>3600</integer> 
</dict> 
</plist>" > /Library/LaunchDaemons/com.admin.disableAdmin.plist
#####

# Set the permission on the file just made.
chown root:wheel /Library/LaunchDaemons/com.admin.disableAdmin.plist
chmod 644 /Library/LaunchDaemons/com.admin.disableAdmin.plist
defaults write /Library/LaunchDaemons/com.admin.disableAdmin.plist disabled -bool false

# Load the removal plist timer. 
launchctl load -w /Library/LaunchDaemons/com.admin.disableAdmin.plist

# Build log files in var/adminLogs/
mkdir /var/adminLogs
TIME=`date "+Date:%m-%d-%Y TIME:%H:%M:%S"`
echo $TIME "Admin rights enabled for" $User >> /var/adminLogs/60minAdmin.txt

echo $User >> /var/adminLogs/userToRemove

# give current logged user admin rights
/usr/sbin/dseditgroup -o edit -a $User -t user admin
exit 0
