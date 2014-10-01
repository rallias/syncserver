#!/bin/bash

SYNCSERVER_PUBLIC_URL=${SYNCSERVER_PUBLIC_URL:-http://localhost:5000}
if [ -f /home/app/data/syncserver_secret ]
then
	SYNCSERVER_SECRET=$(cat /home/app/data/syncserver_secret)
else
	SYNCSERVER_SECRET=${SYNCSERVER_SECRET:-$(head -c 20 /dev/urandom | sha1sum)}
	echo "$SYNCSERVER_SECRET" > /home/app/data/syncserver_secret
fi
SYNCSERVER_ALLOW_NEW_USERS=${SYNCSERVER_ALLOW_NEW_USERS:-false}

echo "[server:main]
use = egg:Paste#http
host = 0.0.0.0
port = 5000
[app:main]
use = egg:syncserver
[syncserver]
public_url = $SYNCSERVER_PUBLIC_URL
sqluri = sqlite:////home/app/data/syncserver.db
secret = $SYNCSERVER_SECRET
allow_new_users = $SYNCSERVER_ALLOW_NEW_USERS
" > syncserver.ini

/usr/bin/make serve
