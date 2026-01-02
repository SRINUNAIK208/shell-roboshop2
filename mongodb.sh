#!/bin/bash

source ./common.sh
app_Name=mongodb

check_rootuser



cp mongo.repo /etc/yum.repos.d/mongodb.repo &>>$Logs_file
VALIDATE $? "mongodb repo setup done"

dnf install mongodb-org -y &>>$Logs_file
VALIDATE $? "mongodn installation is done"

systemctl enable mongod &>>$Logs_file
systemctl start mongod &>>$Logs_file
VALIDATE $? "enabled and started mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$Logs_file
VALIDATE $? "Editing conf file for remote connection" 

systemctl restart mongod &>>$Logs_file
VALIDATE $? "restarted mongodb"
Print_Time


