#!/bin/bash
# $1 - Switch address
if [ -n "$1" ]
then
	IntDescr=$(snmpwalk -v1 -c saturn-cm $1 iso.3.6.1.2.1.31.1.1.1.18 2>/dev/null)
	echo $IntDescr
else
	echo "First Parameter not found"
fi
