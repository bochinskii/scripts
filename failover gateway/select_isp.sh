#!/usr/bin/bash

ip a sh | grep -q 10.0.0.254 || exit 0

ip route del default 2> /dev/null
ip route add default via 172.16.1.254 dev ens37 2> /dev/null
ping -c3 yandex.ru &> /dev/null
CHECK1=$?

ip route del default 2> /dev/null
ip route add default via 172.16.2.254 dev ens39 2> /dev/null
ping -c3 yandex.ru &> /dev/null
CHECK2=$?

ip route del default 2> /dev/null

test $CHECK1 -eq 0 && test $CHECK2 -ne 0 && CONF_NAME="sp1"
test $CHECK2 -eq 0 && test $CHECK1 -ne 0 && CONF_NAME="sp2"
test $CHECK1 -eq 0 && test $CHECK2 -eq 0 && CONF_NAME="sp1sp2"

touch /tmp/conf_name.txt
CONF_CAT=`cat /tmp/conf_name.txt`
test "$CONF_NAME" = "$CONF_CAT" && exit 0
echo $CONF_NAME > /tmp/conf_name.txt

if [ $CONF_NAME == "sp1" ]
then
  ip rule del prio 100 2> /dev/null
  ip rule del prio 200 2> /dev/null
  ip rule del prio 300 2> /dev/null
  ip route flush table 101 2> /dev/null
  ip route flush table 102 2> /dev/null
  ip route add default via 172.16.1.254 dev ens37
  ip route add default via 172.16.1.254 table 101
  ip rule add prio 100 from 10.0.0.0/24 to 10.0.0.0/24 table main
  ip rule add prio 200 from 10.0.0.0/24 table 101
  ip route flush cache
  conntrack -F
  exit 0
fi

if [ $CONF_NAME == "sp2" ]
then
  ip rule del prio 100 2> /dev/null
  ip rule del prio 200 2> /dev/null
  ip rule del prio 300 2> /dev/null
  ip route flush table 101 2> /dev/null
  ip route flush table 102 2> /dev/null
  ip route add default via 172.16.2.254 dev ens39
  ip route add default via 172.16.2.254 table 102
  ip rule add prio 100 from 10.0.0.0/24 to 10.0.0.0/24 table main
  ip rule add prio 200 from 10.0.0.0/24 table 102
  ip route flush cache
  conntrack -F
  exit 0
fi

if [ $CONF_NAME == "sp1sp2" ]
then
  ip rule del prio 100 2> /dev/null
  ip rule del prio 200 2> /dev/null
  ip rule del prio 300 2> /dev/null
  ip route flush table 101 2> /dev/null
  ip route flush table 102 2> /dev/null
  ip route add default via 172.16.1.254 dev ens37
  ip route add default via 172.16.1.254 table 101
  ip route add default via 172.16.2.254 table 102
  ip rule add prio 100 from 10.0.0.0/24 to 10.0.0.0/24 table main
  ip rule add prio 200 from 10.0.0.0/25 table 101
  ip rule add prio 300 from 10.0.0.128/25 table 102
  ip route flush cache
  conntrack -F
  exit 0
fi
