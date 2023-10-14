#!/bin/bash
# 
# If using the default Cisco Anyconnect pkg to install, some unwanted or unused pieces may also be installed.
# Add to or remove whatever uninstall script you want to run to remove that piece in the "scripts" array

# Array of Cisco Anyconect uninstall scripts to run
scripts=("amp_uninstall.sh" "dart_uninstall.sh" "iseposture_uninstall.sh" "nvm_uninstall.sh" "umbrella_uninstall.sh" "websecurity_uninstall.sh")

# Run each uninstall script for each feature
for item in ${scripts[*]}
	do
		sh /opt/cisco/anyconnect/bin/$item
		printf "%s\n" $item
	done