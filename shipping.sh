#!/bin/bash
source ./common.sh
app_name=shipping
check_rootuser

dnf install maven -y

id roboshop
if [ $? -eq 0 ]
then
   echo "roboshop system user already created..Nothing to do"
else
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
   VALIDATE $? "roboshop user created"
fi

rm -rf /app
mkdir -p /app 

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip 
VALIDATE $? "shipping artifact"

cd /app 
unzip /tmp/shipping.zip
VALIDATE $? "unzip atrifact"

mvn clean package 
VALIDATE $? "maven package"
mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? "jat files copied"

cp $Script_Dir/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "created shiiping service"

systemctl daemon-reload
systemctl enable shipping 
systemctl start shipping
VALIDATE $? "start shiiping service"

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











