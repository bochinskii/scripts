#!/bin/bash
# $1 - ip address of DHCP server (mikrotik), $2 - ssh port
#
LOG_DATE=$(date +%F---%H-%M-%S---:)
LOG_PATH="/etc/zabbix/mikrotik"
#
# Arguments checking
#
if [ -z $1 ] || [ -z $2 ]
then
        echo "0"
        echo "$LOG_DATE Some parameters are not found. You have to define parameters." 1>>$LOG_PATH/template.discovery.mikrotik.dhcp.log
        exit
fi
#
# SSH connection checking
#
ssh -q -p $2 zabbix@$1 exit
if [ $? -ne "0" ]
then
	echo "0"
	echo "$LOG_DATE SSH connection is failed." 1>>$LOG_PATH/template.discovery.mikrotik.dhcp.log
	exit
fi
#
POOLPATH="/etc/zabbix/mikrotik/Pool.data"
LFS=$'\n'
POOLGET=$( ssh -p $2 zabbix@$1  "/ip pool print" | sed '1d' | awk '{ print $2 }' | tr -s '\n\n' '\n' )
TEST=$(
	echo -e "[" | tr -d '\n'
	for POOL in $POOLGET
	do
		echo -e "{\"{#POOLNAME}\":\"$POOL\"}," | tr -d '\n'
	done
	echo -e "]"
)
echo $TEST | sed 's/,]/]/'
