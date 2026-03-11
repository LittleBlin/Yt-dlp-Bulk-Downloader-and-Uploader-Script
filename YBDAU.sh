#!/bin/bash
# Needed packages: sshpass yt-dlp

# Upload settings
clientaddr="192.168.100.X" # IP Address to which the videos will be uploaded after download (Must have set up SSH)
clientport="22" # Port of the client, change in case your device doesnt use port 22 for ssh
clientuser="user" # User that will be logged into
clientpass="resu" # Password for the user
clientfolder="/home/user/Videos" # Where to upload the videos on client
# Folders & files
downloadfolder="./ybdau/downloaded" # Where the videos will be downloaded to
commandlist="./ybdau/yt.txt" # Where the list of URL/command list will be stored
# Misc
ytdlpexe="yt-dlp" # Path to yt-dlp binary
deleteuponupload="true" # Option to delete videos in the downloaded folder after uploading. Setting to false will break the upload but I dont care for this script that much to fix it, whoopde doo

while true
do
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Yt-dlp Bulk Downloader and Uploader Thing"
TITLE="Howdy!"
MENU="Choose one of the following options:"

OPTIONS=(1 "Add URL"
         2 "Reset URL list"
         3 "Check URL list"
         4 "Download videos and upload"
         5 "Download only"
         6 "Edit upload path"
         7 "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            echo "Tell me your URL then:"
            read url
            echo $ytdlpexe $url >> $commandlist
            ;;
        2)
            echo "" > $commandlist
            ;;
        3)
            cat $commandlist
            echo
            echo "yes, those are commands and not urls, gimmie a break. Press enter to continue"
            read
            ;;
        4)
            cd $downloadfolder
            echo "Downloading..."
            bash $commandlist
            echo "Uploading... (May take a while)"
            sshpass -p "$clientpass" scp -P $clientport $downloadfolder/* $clientuser@$clientaddr:$clientfolder/$clientsubfolder
            if [ $deleteuponupload = "true"]; then
            echo "Cleaning..."
            rm -r $downloadfolder/*.webm
            fi
            ;;
        5)
            cd $downloadfolder
            echo "Downloading..."
            bash $commandlist
            ;;
        6)
            echo "Current path: $clientfolder"
            echo "Enter new path:"
            read clientfolder
            ;;
        7)
            exit
            ;;
esac

done
