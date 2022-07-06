#!/bin/bash
#
ZABBIX_USER="denys"
ZABBIX_PASSWORD="Yakagam@220987"
API_PATH="http://127.0.0.1/zabbix/api_jsonrpc.php"
AUTH_KEY=$( curl -s -k -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\": \"2.0\",
	\"method\": \"user.login\",
	\"params\": {
		\"user\": \"$ZABBIX_USER\",
		\"password\": \"$ZABBIX_PASSWORD\"
	},
	\"id\": 1,
	\"auth\": null
}" $API_PATH | awk -F: '{print $3}' | awk -F, '{print $1}' | awk -F\" '{print $2}' )
echo $AUTH_KEY
