#!/bin/sh
# 
# This script is a intended as a bootstrap script to run when a computer is enrolled in the JSS outside of DEP.
#
# Script originally written on 8/23/2017
#
timeServer="time.company.com"
jamfTrigger1="TRIGGERNAME"
jamfTrigger2="TRIGGERNAME"
jamfTrigger3="TRIGGERNAME"
# Add as many Jamf policy triggers as you want. Make sure to replicate this at the bottom of the script.
###################################################################################################################
###################################################################################################################
# Set Time Zone
#/usr/sbin/systemsetup -settimezone "America/Anchorage"
#
# Set Network Time
/usr/sbin/systemsetup -setusingnetworktime on

# Set Time Server
/usr/sbin/systemsetup -setnetworktimeserver $timeServer

# Configure Finder to always open directories in Column view
/usr/bin/defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.finder "AlwaysOpenWindowsInColumnView" -bool true

# Disable Time Machine's pop-up message whenever an external drive is plugged in
/usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Hide Admin User
/usr/bin/defaults write /Library/Preferences/com.apple.loginwindow Hide500Users -bool TRUE

# Disable IPv6
networksetup -setv6off Ethernet && networksetup -setv6off Wi-Fi

# Turn SSH on
/usr/sbin/systemsetup -setremotelogin on

# Turn off Automatic Apple Software Update Checks
#/usr/sbin/softwareupdate --schedule off

# Sets the "Show scroll bars" setting (in System Preferences: General)
# to "Always" in your Mac's default user template and for all existing users.
# Code adapted from DeployStudio's rc130 ds_finalize script, where it's 
# disabling the iCloud and gestures demos

# Checks the system default user template for the presence of 
# the Library/Preferences directory. If the directory is not found, 
# it is created and then the "Show scroll bars" setting is set to "Always".
for USER_TEMPLATE in "/System/Library/User Template"/*
  do
     if [ ! -d "${USER_TEMPLATE}"/Library/Preferences ]
      then
        mkdir -p "${USER_TEMPLATE}"/Library/Preferences
     fi
     if [ ! -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        mkdir -p "${USER_TEMPLATE}"/Library/Preferences/ByHost
     fi
     if [ -d "${USER_TEMPLATE}"/Library/Preferences/ByHost ]
      then
        /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/.GlobalPreferences AppleShowScrollBars -string Always
     fi
  done

# Checks the existing user folders in /Users for the presence of
# the Library/Preferences directory. If the directory is not found, 
# it is created and then the "Show scroll bars" setting (in System 
# Preferences: General) is set to "Always".
for USER_HOME in /Users/*
  do
    USER_UID=`basename "${USER_HOME}"`
    if [ ! "${USER_UID}" = "Shared" ] 
     then 
      if [ ! -d "${USER_HOME}"/Library/Preferences ]
       then
        mkdir -p "${USER_HOME}"/Library/Preferences
        chown "${USER_UID}" "${USER_HOME}"/Library
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ ! -d "${USER_HOME}"/Library/Preferences/ByHost ]
       then
        mkdir -p "${USER_HOME}"/Library/Preferences/ByHost
        chown "${USER_UID}" "${USER_HOME}"/Library
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
    chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/ByHost
      fi
      if [ -d "${USER_HOME}"/Library/Preferences/ByHost ]
       then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/.GlobalPreferences AppleShowScrollBars -string Always
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/.GlobalPreferences.*
      fi
    fi
  done

# Pass the trigger for any Jamf policies you want to run after this bootstrap script
/usr/local/bin/jamf policy -trigger $jamfTrigger1
/usr/local/bin/jamf policy -trigger $jamfTrigger2
/usr/local/bin/jamf policy -trigger $jamfTrigger3

