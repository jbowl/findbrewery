#!/bin/ash

# sed to alter files in dist by env variables

echo "using $tls_bypass as tls_bypass"

if [ "$tls_bypass" = "true" ]
then     
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.tls
    mv /etc/nginx/nginx.conf.no_tls /etc/nginx/nginx.conf
fi 
# else use default nginx.conf wired up for tls

echo "attempting to start nginx"

nginx -g "daemon off;"