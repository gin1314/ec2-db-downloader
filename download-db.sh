#!/bin/bash

ARG_IP=$1
ARG_IDENTITY_FILE=$2
STAGING_IP=${ARG_IP:=""}
DUMP_FILE="dump.sql.tar.gz"
IDENTITY_FILE=${ARG_IDENTITY_FILE:=""}

if [[ $STAGING_IP == "" ]] || [[ $IDENTITY_FILE == "" ]] ; then
	echo -e "\nUsage: $0 IP_ADDRESS IDENTITY_FILE\n"
	echo -e "\e[38;5;82mExample: $0 54.88.88.88 certificate-staging.pem\e[0m\n\n"
	exit 0
fi

read -p "You really want to dump remote database? [Y/n]: " option

if [[ "$option" =~ ^[yY]$ ]]; then
    cmd=`cat remote_command.sh | sed 's,#!/bin/bash,,'`
    echo -e "\e[38;5;82m[+]\e[0m performing remote command: \e[38;5;222m${cmd}\e[0m\n\n"
    echo -e "\e[38;5;82mssh-ing to ec2-user@$STAGING_IP\e[0m"
    
    read -p "login to server? [Y/n]: " login
    if [[ "$login" =~ ^[yY]$ ]]; then
        ssh ec2-user@${STAGING_IP} -i ${IDENTITY_FILE} 'bash -s' < remote_command.sh

        read -p "download dump from server? [Y/n]: " download
        if [[ "$download" =~ ^[yY]$ ]]; then
        	echo -e "\e[38;5;114mdownloading $DUMP_FILE file via scp...\e[0m"
            scp -i ${IDENTITY_FILE} ec2-user@${STAGING_IP}:/tmp/dump.sql.tar.gz dump.sql.tar.gz
        fi

    fi
    
    echo -e "\e[38;5;10mdone\e[0m" 
else
    echo -e "\e[38;5;124mdownloading cancelled :(\e[0m $STAGING_IP"
    for i in {16..21} {21..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
fi