#!/bin/bash
################################################################################
# This script is used to create an RSA key for a logged in user and stores that
# key in a location you specify such as a SMB fileshare. 
# This is useful for passwordless connection automation.
###########################    WARNING   ##################################
# Make sure the permissions to this fileshare are properly set and that once
# the automation that imports this key is complete, it cleans up the share
# so the keys can not be accessed by anyone else.
# Several security concerns should be addressed before using this method.
################################################################################

# Fill in the variables to fit your environment
certUser="User"
certPass="Password"
serverAddress="server.company.net"
serverShare="shareDirectory"

# Get current logged on user
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`

# Mount the Share that will house the RSA key
mkdir /Volumes/$serverShare
mount -t smbfs //$certUser:$certPass@$serverAddress/$serverShare /Volumes/$serverShare

# Create folder with users name
mkdir /Volumes/$serverShare/$lastUser'_rsa'

# Create RSA key for the logged on user and copy to the server share
echo -ne "\n" | sudo -u $lastUser ssh-keygen -t rsa -b 2048 -N "" -f /Users/$lastUser/.ssh/id_rsa
cp /Users/$lastUser/.ssh/id_rsa.pub /Volumes/$serverShare/$lastUser'_rsa'/
sleep 2

# Unmounts the share and exit
diskutil unmount /Volumes/$serverShare
exit 0