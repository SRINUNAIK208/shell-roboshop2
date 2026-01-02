#!/bin/bash

source ./common.sh
app_name=catalogue
check_rootuser
app_setup
Nodejs_setup
Systemd_setup




cp $Script_Dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$Logs_file
dnf install mongodb-mongosh -y
VALIDATE $? "mongodb client created"

mongosh --host mongodb.srinunayak.online </app/db/master-data.js &>>$Logs_file
VALIDATE $? "data is loading"

Print_Time

