#!/bin/bash
# log_download.sh, version 1.0
#
# This script extracts log files for Ardupilot or PX4 over
# Wifi or from a mounted SD Card. By default the script will
# download logs from Ardupilot from an SD Card.
#
# NOTE: This script will not clean out old logs on the
#       OcPoC SD card, that is up to the user.
#
# Usage:
#   ./log_download.sh <APM|PX4> <IPv4 address|(Blank if Copy from SD Card)>
#
# Options:
# 	APM
#		- will download Ardupilot logs from /var/APM/logs
#	PX4
#		- will download PX4 logs from /root/rootfs/fs/microsd/log
#	IPv4
#		- will download the logs over wifi at the specified IP address
#		- if this input arg is left blank, the script will attempt to
#         download logs from a mounted SD Card

# Set initial variables
home_dir=$PWD
PX4_DIR=root/rootfs/fs/microsd/log
APM_DIR=var/APM/logs
PX4=false
APM=false
IP=false
stack="APM"

# Check input options
if [ ! -z "$1" ] && [ $1 == "PX4" ]; then
    PX4=true
    stack="PX4"
    text1="Downloading PX4 logs"
    echo "you entered PX4 option"
else
    APM=true
    text1="Downloading Ardupilot logs"
fi

if [ ! -z "$2" ]; then
    IP=true
    echo "$text1 over Wifi at IPv4: $2"

    # we use sshpass to avoid spamming the terminal
    # with password prompts. check if the package
    # is already installed.
    dkpg -l sshpass &> /dev/null
    if [ "$?" -ne 0 ]; then
        sudo apt-get -y -qq install sshpass
    fi
    
    # ask user for ocpoc's ssh password
    echo "OcPoC root@$2's password:"
    read -s ocpoc_pw
else
    echo "$text1 from SD Card"
fi

# Make/prepare a log folder:
# If a log folder doesn't already exist, make a new one
if [ ! -d "logs_$stack" ]; then
    mkdir logs_$stack
fi

cd logs_$stack
download_dir=$PWD

# Download any new log files
if $PX4; then
    if $IP; then
        # read PX4 logs directory over SSH
        sshpass -p "$ocpoc_pw" ssh root@$2 ls /$PX4_DIR > existing_logs.txt
    else
        # read PX4 logs directory from SD Card
        sudo ls /media/$USER/rootFs/$PX4_DIR > existing_logs.txt
    fi

    # check for already downloaded logs against PX4 logs on OcPoC
    while read f; do
        if [ ! -d "$f" ]; then
            # if the directory doesn't already exist on host machine,
            # download the entire log directory
            if $IP; then
                sshpass -p "$ocpoc_pw" scp -r root@$2:/$PX4_DIR/$f $download_dir/.
            else
                sudo cp -r /media/$USER/rootFs/$PX4_DIR/$f $download_dir/.
            fi

            # change file ownership from root to $USER
            sudo chown -R $USER:$USER $download_dir/$f
        else
            # if the directory already exists on the host machine,
            # check for any new log files in the log directory
            cd $f

            if $IP; then
                sshpass -p "$ocpoc_pw" ssh root@$2 ls /$PX4_DIR/$f > existing_files.txt
            else
                sudo ls /media/$USER/rootFs/$PX4_DIR/$f > existing_files.txt
            fi

            while read p; do
                # if a file on the ocpoc doesn't exist in the host machine,
                # then copy it over
                if [ ! -e $p ]; then
                    if $IP; then
                        sshpass -p "$ocpoc_pw" scp root@$2:$PX4_DIR/$f/$p $download_dir/$f/.
                    else
                        sudo cp /media/$USER/rootFs/$PX4_DIR/$f/$p $download_dir/$f/.
                    fi

                    # change file ownership from root to $USER
                    sudo chown -R $USER:$USER $download_dir/$f/$p
                fi

            # end 'while read p;' loop
            done < existing_files.txt
            
            # cleanup
            sudo rm existing_files.txt
            cd ..
        fi

    # end 'while read f;' loop
    done < existing_logs.txt
    
    # cleanup
    sudo rm existing_logs.txt
else
    if $IP; then
        # read Ardupilot logs directory over SSH
        sshpass -p "$ocpoc_pw" ssh root@$2 ls /$APM_DIR > existing_logs.txt

    else
        # read Ardupilot logs directory from SD Card
        sudo ls /media/$USER/rootFs/$APM_DIR > existing_logs.txt
    fi
    
    # check for already downloaded logs against APM logs on OcPoC
    while read f; do
        if [ ! -e $f ]; then
            # if the log file doesn't already exist on host machine,
            # download the log
            if $IP; then
                sshpass -p "$ocpoc_pw" scp root@$2:/$APM_DIR/$f $download_dir/.
            else
                sudo cp /media/$USER/rootFs/$APM_DIR/$f $download_dir/.
            fi
        fi
    done < existing_logs.txt

    # cleanup
    sudo rm existing_logs.txt
fi

# final cleanup
cd $home_dir
echo "log download complete"
