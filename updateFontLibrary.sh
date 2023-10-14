#!/bin/bash
#
# This script takes the Master Fonts folder from a Server Share and moves it to 
# Users and Library Fonts and installs them in Font Book.
# This script assumes that the Server Share is already mounted.
# Uses CocoaDialog for UI
####################################################################################
############# Drive share where master font library lives. #########################
####################################################################################
fontDrive="/PATH/TO/FONT/DIR/LOCATION/"

####################################################################################
############### Get User input and create variables#################################
####################################################################################
lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
pathToSysLib='/System/Library/User Template/Non_localized/Library/Fonts'
pathToUserLib='/Users/'$lastUser'/Library/Fonts'
echo variables set
############ Location of CocoaDialog.app ###########################################
CD_APP="/Users/Shared/CocoaDialog.app/"
CD="$CD_APP/Contents/MacOS/CocoaDialog"

####################################################################################
############### Check that the Network Volume is Mounted ###########################
####################################################################################
if [ -d $fontDrive ]; then
   dirLoc= $fontDrive
   echo Found Directory
else
	echo "No"
	noDir=`$CD msgbox --title "Error" \
	--text "Font Drive is not mounted" \
	--no-newline --button1 "Ok" --float`
   	exit 0
fi
####################################################################################
####################### First Dropdown Menu ########################################
####################################################################################
request=`$CD msgbox --title "Font Updater" \
--text "Would you like to clear OLD user fonts first?" \
--no-newline --button1 "Yes" --button2 "No" --button3 "Cancel" --float`
#
# See if Cancel button was clicked. If so then exit
#
if [[ "$cancel" == "Cancel" ]] || [[ "$cancel2" == "Cancel" ]]; then
	echo "Cancel Button Clicked"
	exit 0
fi
####################################################################################
###################### Do things with user input ###################################
####################################################################################
echo $request
if [ "$request" == "1" ]; then
	echo "User selected yes"
		rm -rf $pathToUserLib
		echo "removed User Fonts"
		rm -rf $pathToSysLib
		echo "removed Sys Fonts"
	elif [ "$request" == "2" ]; then
		echo "No"
	elif [ "$request" == "3" ]; then
		exit 0
fi
####################################################################################
########### Change Dir and check to see that you are in the correct one ############
############################# If not, Exit with error ##############################
################# If Dir is correct then transfer to User Library ##################
####################################################################################
cd "$dirLoc"
	if [[ $PWD/ = $dirLoc ]] ; then
		echo $PWD
		rsync -avm --include='*.ttf' --include='*.otf' -f 'hide,! */' . "$pathToUserLib"
		echo Synced To $lastUser Library
	elif [[ $PWD/ != $dirLoc ]] ; then
    	echo Wrong Location or Drive Not Mapped
	fi
############### If User template Fonts do not exist create the dir ################
############################### Then Copy Fonts to it #############################

	if [[ ! -e "$pathToSysLib" ]]; then
		echo Creating User Template Fonts Directory
    	mkdir -p "$pathToSysLib"
    	echo Copying Data  
 	   rsync -avm --include='*.ttf' --include='*.otf' -f 'hide,! */' . "$pathToSysLib"
	else
		echo Directory exists. Copying Files
		rsync -avm --include='*.ttf' --include='*.otf' -f 'hide,! */' . "$pathToSysLib"
	fi