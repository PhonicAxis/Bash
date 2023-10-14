#!/bin/bash
# Puts specific applications in the logged in Users dock.
#
# Application to add to Dock (Google Chrome in this example)
app="/Applications/Google\ Chrome.app"

# Get the current logged on User and set the path for their dock plist
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
pathToPlist='/Users/'$lastUser'/Library/Preferences/com.apple.dock'

# Write the Application to the dock plist
# Uncomment below to impersonate the user if not deploed by MDM.
# sudo -u $lastUser defaults write $pathToPlist persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
defaults write $pathToPlist persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"

# Reload Dock plist
killall Dock