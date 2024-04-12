#!/bin/bash

set -e
START_TIME=$(date +%s)

docker-compose build app_blue

NGINX_INSTANCE=$(docker-compose ps | awk '{print $1}' | grep balancer)
if [[ -z $NGINX_INSTANCE ]]
then
    echo "Nginx is not running, cannot continue"
    exit 1
fi

APP_VERSION=$(docker exec $NGINX_INSTANCE cat /app_version)
APP_VERSION=${APP_VERSION:-'blue'}
if [[ $APP_VERSION = "blue" ]]
then
  ACTIVE="blue"
  INACTIVE="green"
else
  ACTIVE="green"
  INACTIVE="blue"
fi

echo "Starting up new version"
docker-compose stop app_$INACTIVE
docker-compose up -d app_$INACTIVE

echo "Rerouting traffic from app_$ACTIVE to app_$INACTIVE"
docker exec $NGINX_INSTANCE ln -sf /etc/nginx/sites-available/$INACTIVE.conf /etc/nginx/conf.d/default.conf
docker exec $NGINX_INSTANCE sh -c "echo $INACTIVE > /app_version"
docker exec $NGINX_INSTANCE nginx -s reload

echo "Shutting down app_$ACTIVE"
docker-compose stop app_$ACTIVE
echo "Successfully deployed app_$INACTIVE on $(date)"

END_TIME=$(date +%s)
DIFF=$(( END_TIME - START_TIME ))
echo "Deploy time: $(printf '%02dm:%02ds\n' $(($DIFF/60)) $(($DIFF%60)))"
echo "Total image size: $(docker images | grep app_base | awk '/app_base/ {print $7}')"
