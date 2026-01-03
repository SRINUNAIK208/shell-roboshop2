
#!/bin/bash

source ./common.sh
app_name=redis
check_rootuser

redis_setup

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$Logs_file
VALIDATE $? "remote ports are changed"

sed  -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis.conf &>>$Logs_file
VALIDATE $? "protection mode changed"

systemctl enable redis &>>$Logs_file
systemctl start redis &>>$Logs_file
VALIDATE $? "enable and start"

Print_Time
