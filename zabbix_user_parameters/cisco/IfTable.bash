#!/bin/bash
#
# $1 - ipaddress snmp agent, $2 - SNMP community, $3 - Table's oid index, $4 - Interface's OID index $5 - SNMP agent version (1 or 2c)
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
if [ $3 -eq 2 ]
then
	snmpwalk -v$5 -c $2 $1 .1.3.6.1.2.1.2.2.1.$3.$4 | cut -d= -f2 | cut -d\" -f2
	exit
fi
if [ $3 -eq 1 ] || [ $3 -ge 3 ] && [ $3 -le 5 ] || [ $3 -eq 7 ] || [ $3 -eq 8 ] || [ $3 -ge 10 ] && [ $3 -ne 12 ] && [ $3 -ne 18 ] && [ $3 -le 20 ]
then
	snmpwalk -v$5 -c $2 $1 .1.3.6.1.2.1.2.2.1.$3.$4 | cut -d= -f2 | cut -d: -f2 | tr -d [:blank:]
	exit
fi
if [ $3 -eq 6 ]
then
	snmpwalk -v$5 -c $2 $1 .1.3.6.1.2.1.2.2.1.$3.$4 | cut -d= -f2 | cut -d: -f2 | sed 's%\"\"%none%' | sed 's% %:%g' | cut -c 2- | sed 's%:$% %' | tr -d [:blank:]
	exit
fi
if [ $3 -eq 9 ]
then
	snmpwalk -v$5 -c $2 $1 .1.3.6.1.2.1.2.2.1.$3.$4 | cut -d= -f2 | sed 's%:%@%' | cut -d@ -f2 | sed 's% %@%' | tr -d @
	exit
fi
echo 0
