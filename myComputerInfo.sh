#!/bin/sh
##############################################################################################
# This can be used as a Policy in Jamf Self Service that allows the user to get their current
# computer information in one place. There is also an option to take a screenshot so they can 
# send this information to a help desk technician.
##############################################################################################

# Location of the Jamf Helper for UI
JHELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Variables to gather computer info
USERNAME=$(ls -l /dev/console | awk '{print $3}')
MACNAME=$(scutil --get ComputerName)
PORT=$(/usr/sbin/netstat -rn -f inet | awk '/default/{print $NF; exit}')
IPADDRESS=$(ipconfig getifaddr $PORT)
MACADDRESS=$(networksetup -getmacaddress $PORT | awk '{print $3}')

# The format of the message presented to the User with their computer information
MESSAGE="You are logged in as:     $USERNAME
Computer name:          $MACNAME
IP Address:             $IPADDRESS
MAC Address:            $MACADDRESS"

# The message provided to the User with their information and the option of a screenshot.
THEMESSAGE=$("$JHELPER" -windowType utility -title "Your Computer Information" -description "$MESSAGE" -button1 "OK" -button2 "Screenshot" -defaultButton 1 -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns" -iconSize 64)

# Screenshot function that is called if the User clicks the screenshot button. This saves the
# screenshot to the Users Desktop.
function SCREENSHOT 
{
SECONDMESSAGE=$("$JHELPER" -windowType utility -title "Your Computer Information" -description "$MESSAGE" -button1 "OK" -button2 "Screenshot" -defaultButton 1 -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericNetworkIcon.icns" -iconSize 64) &
	if [ "$SECONDMESSAGE" == "0" ]; then
       exit 0
	elif [ "$THEMESSAGE" == "2" ]; then
       DATE=$(date +"%Y-%m-%d at%l.%M.%S %p")
       sleep 1
       screencapture -t png "/Users/$USERNAME/Desktop/Screen Shot ${DATE}.png"
       chown ${USERNAME}:staff "/Users/$USERNAME/Desktop/Screen Shot ${DATE}.png"
       exit 0
	fi
}

# The actual logic
if [ "$THEMESSAGE" == "0" ]; then
    exit 0
elif [ "$THEMESSAGE" == "2" ]; then
	SCREENSHOT
fi