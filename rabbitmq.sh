#!/bin/bash

source ./common.sh
app_name=rabbitmq
check_rootuser






cp $Script_Dir/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$Logs_file
VALIDATE $? "rabbitmq repo setup"

dnf install rabbitmq-server -y &>>$Logs_file
VALIDATE $? "rabbitmq"

systemctl enable rabbitmq-server &>>$Logs_file
systemctl start rabbitmq-server &>>$Logs_file
VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$Logs_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Logs_file
VALIDATE $? "username and password setup for rabbitmq"

Print_Time