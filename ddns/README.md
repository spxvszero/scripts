### This Content Save Some Provider DDNS Update Script

#### Cloudflare

Using API to change DNS record. more detail from : https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records

Usage : 

edit `cloudflare_ddns.sh` and fill some parameters.

```bash
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

```

Get your public ip can use free API in some website provided. You can also build a simple nginx server return your ip. Here is an nginx config example:

```nginx
location /ip {
    default_type text/plain;
    return 200 $remote_addr;
}
```

After you finish it,  you can simply finish fetchMyIp() function with your url.

```bash
#this function is to get your public ip, you can finish with simple nginx server or other free api.
function fetchMyIp()
{
	new_ip=`curl some_free_ip.com/ip`
}
```



### Google

Google sold their domains services to Squarespace on June 15, 2023 ....

This script need to add your ip, domain and authorization. Using with google ddns api.

You can found it on : https://support.google.com/domains/answer/6147083?hl=en

