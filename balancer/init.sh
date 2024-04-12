#!/bin/bash

APP_VERSION=$(cat /app_version)

if [[ -z $APP_VERSION ]]
then
  echo 'blue' > /app_version
  APP_VERSION=blue
fi

ln -sf /etc/nginx/sites-available/$APP_VERSION.conf /etc/nginx/conf.d/default.conf

# Start Nginx
nginx -g 'daemon off;'
