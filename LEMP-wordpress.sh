#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install docker.io -y
sudo usermod -aG root ubuntu
sudo usermod -aG docker ubuntu
mkdir wordpress database


sudo docker network create my-net

sudo docker run -td --name db \
-e MYSQL_ROOT_PASSWORD=pass1234 \
-e MYSQL_DATABASE=wordpressdb \
-e MYSQL_USER=ashutosh \
-e MYSQL_PASSWORD=ashu1234 \
-v /home/ubuntu/database:/var/lib/mysql \
--net my-net mariadb

sudo docker run -td --name wordpress \
-e WORDPRESS_DB_HOST=db:3306 \
-e WORDPRESS_DB_NAME=wordpressdb \
-e WORDPRESS_DB_USER=ashutosh \
-e WORDPRESS_DB_PASSWORD=ashu1234 \
-v /home/ubuntu/wordpress:/var/www/html \
--net my-net wordpress:5.7.1-fpm-alpine

sudo docker run -td --name nginx-web \
-p 80:80 \
-v /home/ubuntu/wordpress:/var/www/html \
-v /home/ubuntu/nginx:/etc/nginx/conf.d \
--net my-net nginx:1.20.0-alpine

sudo ufw allow 80/tcp
sudo ufw enable -y
sudo ufw reload


