#!/bin/bash

#this script is update dns record in cloudflare like ddns.
#details : https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records

#intput what your params below
zone_identify="click your domain overview web page. you will see the Zone ID on right side."
changeDomain="this is the domain name u want to change"
new_ip="this ip can write directly or use fetchMyIp() function below to finish it."

#select one auth type of them and fill with it, for more details : https://developers.cloudflare.com/logs/logpull/requesting-logs/#required-authentication-headers
#auth email : your cloudflare account
#auth key : can use global api token
x_auth_email=""
x_auth_key=""
#or bearer from : https://dash.cloudflare.com/profile/api-tokens
x_auth_bearer="This is from api token you created. Zone DNS edit and read premission need here."


#do not input any string to params below unless you know what they do.
record_identify=""
authParmas=""
#this function is api for update dns, details: https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-update-dns-record
function UpdateDNSRecord()
{
	command_updatelist="curl --request PUT \
  --url https://api.cloudflare.com/client/v4/zones/${zone_identify}/dns_records/${record_identify} \
  --header 'Content-Type: application/json' ${authParmas} \
  --data '{
  \"content\": \"'${new_ip}'\",
  \"name\": \"'${changeDomain}'\",
  \"proxied\": false,
  \"type\": \"A\",
  \"comment\": \"Domain Record Updated From Script\",
  \"tags\": [
  ],
  \"ttl\": 3600
}'"
	response_updatelist=`eval ${command_updatelist}`

	getUpdateRes=`echo ${response_updatelist}|jq '.success'`

	if [[ -n ${getUpdateRes} ]]; then
		#statements
		if [[ ${getUpdateRes} = 'true' ]]; then
			#statements
			echo "Update Success."

		else
			echo "Update Domains Record Failed with Response."
			echo ${response_updatelist}
			exit 0
		fi
	else
		echo "Update Domains Record Failed with Serailize Response."
		exit 0
	fi
}

#this function is api for list dns, details: https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
function GetIdentifyForDomain()
{
	command_getlist="curl --request GET \
	  --url https://api.cloudflare.com/client/v4/zones/${zone_identify}/dns_records \
	  --header 'Content-Type: application/json' ${authParmas}"
	response_getlist=`eval ${command_getlist}`

	getRes=`echo ${response_getlist}|jq '.success'`

	if [[ -n ${getRes} ]]; then
		#statements
		if [[ ${getRes} = 'true' ]]; then
			#statements
			record_identify=`echo ${response_getlist}|jq -r ".result[] | select(.name==\"${changeDomain}\") | .id"`
			if [[ -n ${record_identify} ]]; then
				#statements
				record_identify=`echo ${response_getlist}|jq -r ".result[] | select(.name==\"${changeDomain}\") | .id"`

				if [[ -n ${record_identify} ]]; then
					#statements
					echo "Get Record Identify Success. The Idnetify is ${record_identify} Next Update DNS Record >>> "
					UpdateDNSRecord 
				fi
			else
				echo "Could not find the domain record you want."
				exit 0
			fi

		else
			echo "Get Domains Record List Failed with Response."
			echo ${response_getlist}
			exit 0
		fi
	else
		echo "Get Domains Record List Failed with Serailize Response."
		exit 0
	fi
}

#this function is check which auth you pick.
function CheckWhichAuthType()
{
	if [[ -n ${x_auth_bearer} ]]; then
		#statements
		authParmas='--header "Authorization: Bearer '${x_auth_bearer}'"'
		echo "Auth Type Change To Bearer."
		return
	fi

	if [[ -n ${x_auth_key} && -n ${x_auth_email} ]]; then
		#statements
		authParmas=" --header \"X-Auth-Email: ${x_auth_email}\" --header \"X-Auth-Key: ${x_auth_key}\" "
		echo "Auth Type Change To Auth Key."
		return
	fi

	echo "Need Auth Input. Check Bearer or AuthKey."
}

#this function is to get your public ip, you can finish with simple nginx server or other free api.
function fetchMyIp()
{
	new_ip=`curl some_free_ip.com/ip`
}

#check curl,jq command if exist.
function checkCommandIfExist()
{
	if ! command -v curl &> /dev/null
	then
	    echo "curl could not be found. please install curl command."
	    exit 0
	fi

	if ! command -v jq &> /dev/null
	then
	    echo "jq could not be found. please install jq command."
	    exit 0
	fi
}

checkCommandIfExist
fetchMyIp
CheckWhichAuthType
GetIdentifyForDomain
