#!/bin/bash

source ./common.sh
check_rootuser
Nodejs_setup



systemctl enable nginx 
systemctl start nginx 
VALIDATE $? "enabled and started nginx"

rm -rf /usr/share/nginx/html/* 
VALIDATE $? "removed defsult content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
VALIDATE $? "Downloaded roboshop artifact"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
VALIDATE $? "unzip artifact"

cp $Script_Dir/nginx.conf /etc/nginx/nginx.conf
VALIDATE $? "setup roboshop application"

systemctl restart nginx 
VALIDATE $? "restared nginx server"