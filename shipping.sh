#!/bin/bash
source ./common.sh
app_name=shipping
check_rootuser

dnf install maven -y
app_setup

mvn clean package 
VALIDATE $? "maven package"
mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? "jat files copied"

Systemd_setup

dnf install mysql -y 
VALIDATE $? "sql client"

mysql -h sql.srinunayak.online -uroot -pRoboShop@1 < /app/db/schema.sql
VALIDATE $? "loading schema"

mysql -h sql.srinunayak.online -uroot -pRoboShop@1 < /app/db/app-user.sql 
VALIDATE $? "loading user data"

mysql -h sql.srinunayak.online -uroot -pRoboShop@1 < /app/db/master-data.sql
VALIDATE $? "loading Master data"

systemctl restart shipping
VALIDATE $? "restart shipping service"

Print_Time











