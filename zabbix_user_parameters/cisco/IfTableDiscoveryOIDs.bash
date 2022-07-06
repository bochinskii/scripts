#!/bin/bash
#
# $1 - ipaddress snmp agent, $2 - SNMP community, $3 - Interface's oid index
#
# OIDS:
# .1.3.6.1.2.1.2.2.1.2 - ifDescr
# .1.3.6.1.2.1.2.2.1.3 - ifType
# .1.3.6.1.2.1.2.2.1.4 - ifMtu
# .1.3.6.1.2.1.2.2.1.5 - ifSpeed
# .1.3.6.1.2.1.2.2.1.6 - ifPhysAddress
# .1.3.6.1.2.1.2.2.1.7 - ifAdminStatus
# .1.3.6.1.2.1.2.2.1.8 - ifOperStatus
# .1.3.6.1.2.1.2.2.1.9 - ifLastChange
# .1.3.6.1.2.1.2.2.1.10 - ifInOctets
# .1.3.6.1.2.1.2.2.1.11 - ifInUcastPkts
# .1.3.6.1.2.1.2.2.1.13 - ifInDiscards
# .1.3.6.1.2.1.2.2.1.14 - ifInErrors
# .1.3.6.1.2.1.2.2.1.15 - ifInUnknownProtos
# .1.3.6.1.2.1.2.2.1.16 - ifOutOctets
# .1.3.6.1.2.1.2.2.1.17 - ifOutUcastPkts
# .1.3.6.1.2.1.2.2.1.19 - ifOutDiscards
# .1.3.6.1.2.1.2.2.1.20 - ifOutErrors
#
IFS=$'\n'
COLLUM_VALUE_OUT=$( echo -e "[" | tr -d '\n'
for COLLUM_VALUE in $( snmpwalk -v2c -c $2 $1 .1.3.6.1.2.1.2.2.1.$3 | cut -d= -f1 | tr -d [:blank:] )
do
       	echo "{\"{#IF_TABLE_ELEMENT}\":\"$COLLUM_VALUE\"},"
done
echo -e "]"
)
echo $COLLUM_VALUE_OUT | sed 's%, ]%]%'
#echo "[\"{No Such Instance currently exists at this OID}\"]"
