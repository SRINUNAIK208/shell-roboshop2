#!/bin/bash

source ./common.sh
app_name=mysql
check_rootuser

dnf install mysql-server -y
VALIDATE $? "mysql"

systemctl enable mysqld
systemctl start mysqld  
VALIDATE $? "enable and start"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "set password"
Print_Time