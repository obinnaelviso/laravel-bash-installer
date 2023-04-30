#!/bin/bash

# Get project folder path
PROJECT_PATH=$1
DOMAIN=$2

if [ -z $PROJECT_PATH ]; then
    echo "Please provide website full path as first argument"
    exit 1
fi

if [ -z $DOMAIN ]; then
    echo "Please provide domain of website as second argument"
    exit 1
fi

# test path exists
if [ ! -d $PROJECT_PATH ]; then
    echo "Project folder does not exist"
    exit 1
fi

WEBSITE_PATH="/var/www/html/$DOMAIN"

# sudo chown -R www-data:www-data $PROJECT_PATH
# sudo chmod -R 0755 $PROJECT_PATH

mv $PROJECT_PATH $WEBSITE_PATH

# create symlink to project folder
ln -s $WEBSITE_PATH $PROJECT_PATH

# replace variables in sample file
export PATH_TO_PROJECT=$WEBSITE_PATH DOMAIN=$DOMAIN

# create nginx config file from template
envsubst '$PATH_TO_PROJECT $DOMAIN' < nginx-laravel-conf > /etc/nginx/sites-available/$DOMAIN

# Enable website
ln -s /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/$DOMAIN

nginx -t
systemctl restart nginx

echo "Website $DOMAIN is ready to use"
