#!/bin/bash

# Using Google ddns api.
# more details : https://support.google.com/domains/answer/6147083?hl=en 
# The API requires HTTPS. Here’s an example request:
# https://username:password@domains.google.com/nic/update?hostname=subdomain.yourdomain.com&myip=1.2.3.4
# username and password you can find it on your domain dns advanced config web page.

myDomain=""
ip=`curl some_free_ip.com/ip`

# your can use proxy
# curl -x socks5://auth:pwd@xxxx.com:12345 "https://2exvg5mpqHYkJttX:1XkkEvtntZTOVEkJ@domains.google.com/nic/update?hostname=${myDomain}&myip=${ip}"

# or call directly if your can access google

curl "https://username:password@domains.google.com/nic/update?hostname=${myDomain}&myip=${ip}"

