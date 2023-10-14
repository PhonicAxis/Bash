#!/bin/bash

#Grab the username of the user that last logged in (current user)
currentUser=`ls -l /dev/console | cut -d " " -f 4`

# Submit an inventory report and include the current user to be written to the 
# username field in the Users and Location Information in JSS.
sudo jamf recon -endUsername $currentUser

exit 0