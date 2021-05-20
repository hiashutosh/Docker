#!/bin/bash

# these first five commands are generally required for those system which are completely fresh 
# if docker is installed on system then you can delete these commands
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install docker.io -y
sudo usermod -aG root ubuntu
sudo usermod -aG docker ubuntu

#making directories for data persistency
mkdir wordpress database nginx

# download the nginx config file from git repo
url=https://raw.githubusercontent.com/hiashutosh/Docker/master/nginx/nginx.conf 
cd nginx/
curl $url > nginx.conf
cd ../

# creating a new network in docker
sudo docker network create my-net

# running the docker container for Database
sudo docker run -td --name db \
-e MYSQL_ROOT_PASSWORD=pass1234 \
-e MYSQL_DATABASE=wordpressdb \
-e MYSQL_USER=ashutosh \
-e MYSQL_PASSWORD=password \
-v /home/ubuntu/database:/var/lib/mysql \
--net my-net mariadb

# running the docker container for Database
sudo docker run -td --name wordpress \
-e WORDPRESS_DB_HOST=db:3306 \
-e WORDPRESS_DB_NAME=wordpressdb \
-e WORDPRESS_DB_USER=ashutosh \
-e WORDPRESS_DB_PASSWORD=password \
-v /home/ubuntu/wordpress:/var/www/html \
--net my-net wordpress:5.7.1-fpm-alpine

# running the docker container for Nginx
sudo docker run -td --name nginx-web \
-p 8080:80 \
-v /home/ubuntu/wordpress:/var/www/html \
-v /home/ubuntu/nginx:/etc/nginx/conf.d \
--net my-net nginx:1.20.0-alpine

# allow traffic on port 8080
sudo ufw allow 8080/tcp
sudo ufw enable
sudo ufw reload
