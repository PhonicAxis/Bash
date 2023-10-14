#!/bin/bash
#
# The local admin (or any account you do not want to remove)
admin="LOCALADMIN"

# Array of Users on the machine that have not logged in for over 60 days.
# Append '!' -path /Users/USERNAME for any user you do not wish to remove.
arr=($(find /Users -maxdepth 1 -mtime +60d '!' -path /Users/$admin '!' -path /Users/Shared '!' -path /Users '!' -path /Users/.DS_Store '!' -path /Users/.localized '!' -path /Users/Guest))

# Itterate throught the arry of users removing the accounts.
for item in ${arr[*]}
  do
        echo "$item"
        dscl . delete "$item"  #delete the account
        rm -r "$item"  #delete the home directory
done