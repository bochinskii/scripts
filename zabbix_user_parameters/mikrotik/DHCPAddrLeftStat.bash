#!/bin/bash
# $1 - ip address DHCP Server, $2 - ssh port, $3 - name's DHCP pool, $4 - "DEF" shows defined addresses, "LEFT" shows last addresses, "USED" shows used addresses in curent time
#
LOG_PATH="/etc/zabbix/mikrotik"
LOG_DATE=$(date +%F---%H-%M-%S---:)
#
# Arguments checking
#
if [ -z $1 ] || [ -z $2 ] || [ -z $3 ] || [ -z $4 ]
then
	echo "0"
	echo "$LOG_DATE Some parameters are not found. You have to define parameters." 1>>$LOG_PATH/template.mikrotik.dhcp.log 
	exit
fi
#
PP1=$1
PP2=$2
PP3=$3
PP4=$4
#
# SSH connection checking
#
ssh -q -p $2 zabbix@$1 exit
if [ $? -ne "0" ]
then
	echo "0"
	echo "$LOG_DATE SSH connection is failed." 1>>$LOG_PATH/template.mikrotik.dhcp.log
	exit
fi
#
# Get current (used) IP adresses
#
ADD_COUNT_CUR=$( ssh -q -p $2 zabbix@$1 "/ip pool used print count-only where pool=$3" | sed 's/\r$//' )
if [ -z $ADD_COUNT_CUR ]
then
#	echo "$LOG_DATE Value about used addresses \"$PP1\" in pool \"$PP3\" is not found" 1>>$LOG_PATH/template.mikrotik.dhcp.log
	exit
fi
if [ $4 = "USED" ]
then
	echo $ADD_COUNT_CUR
	exit
fi
#
# Get first and last addresses in pool range
#
NET=$( ssh -q -p $2 zabbix@$1  "/ip pool print where name=$3" | sed '1d' | awk '{ print $3 }' | tr -s '\n\n' '\n' )
if [ -z $NET ]
then
#	echo "$LOG_DATE Value about shared network \"$PP1\" in pool \"$PP3\" is not found" 1>>$LOG_PATH/template.mikrotik.dhcp.log
	exit
fi
# Get first an last addresses in pool range separately (ADD_1 and ADD_2)
IFS="-"
NUM_ADD=0
for ADD in $NET
do
#       echo "This is address - \"$ADD\""
        NUM_ADD=$(( $NUM_ADD + 1 ))
        eval ADD_$NUM_ADD=$ADD
done
#
# Get octets from first ip address separately (OCT_FIRST_1, OCT_FIRST_2, OCT_FIRST_3, OCT_FIRST_4)
#
IFS="."
NUM_OCT_FIRST=0
for OCT_FIRST in $ADD_1
do
#       echo "This is octet - \"$OCT_FIRST\""
        NUM_OCT_FIRST=$(( $NUM_OCT_FIRST + 1 ))
        eval OCT_FIRST_$NUM_OCT_FIRST=$OCT_FIRST
done
#
# Get octets from last ip address separately (OCT_LAST_1, OCT_LAST_2, OCT_LAST_3, OCT_LAST_4)
#
NUM_OCT_LAST=0
for OCT_LAST in $ADD_2
do
#       echo "This is octet - \"$OCT_LAST\""
        NUM_OCT_LAST=$(( $NUM_OCT_LAST + 1 ))
        eval OCT_LAST_$NUM_OCT_LAST=$OCT_LAST
done
#
# Convert IP addresses in TEN format and calculate (OCT)
#
OCT_FIRTS_TEN=$(( ($OCT_FIRST_4*256**0 + $OCT_FIRST_3*256**1 + $OCT_FIRST_2*256**2 + $OCT_FIRST_1*256**3) + 1 ))
OCT_LAST_TEN=$(( ($OCT_LAST_4*256**0 + $OCT_LAST_3*256**1 + $OCT_LAST_2*256**2 + $OCT_LAST_1*256**3) + 1  ))
OCT=$(( ($OCT_LAST_TEN - $OCT_FIRTS_TEN) + 1 ))
#echo $OCT
#
# Calculate IP addresses with left (ADD_COUNT_LAST)
#
ADD_COUNT_LAST=$(( ($OCT - $ADD_COUNT_CUR) ))
#echo $ADD_COUNT_LAST
#
if [ $4 = "DEF" ]
then
	echo $OCT
	exit
fi
if [ $4 = "LEFT" ]
then
	echo $ADD_COUNT_LAST
	exit
fi
