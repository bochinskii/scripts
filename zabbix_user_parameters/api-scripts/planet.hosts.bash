#!/bin/bash
#
# Get user's auth key
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
#echo $AUTH_KEY
#
# Take host id from planetarium group
#
HOST_ID_NF=$( curl -s -k -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\": \"2.0\",
	\"method\": \"hostgroup.get\",
	\"params\": {
		\"selectHosts\": \"\",
		\"filter\": {
			\"name\": [
				\"Planetarium infrastructure\"
			]
		}
	},
	\"id\": 2,
	\"auth\": \"$AUTH_KEY\"
}" $API_PATH | jq '.result | .[] | .hosts[] | .hostid' )
HOST_ID=$( echo $HOST_ID_NF | sed 's! !,!g' )
#echo "$HOST_ID"
#
# Take host names from planetarium group
#
HOST_NAME=$( curl -s -k -X POST -H 'Content-Type: application/json-rpc' -d "
{
	\"jsonrpc\": \"2.0\",
	\"method\": \"host.get\",
	\"params\": {
		\"output\": [
			\"host\"
		],
		\"filter\": {
			\"hostid\": [
				$HOST_ID
			]
		}
	},
	\"id\": 3,
	\"auth\": \"$AUTH_KEY\"
}" $API_PATH )
echo $HOST_NAME | jq '.result [] | .host'
