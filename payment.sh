#!/bin/bash
source ./common.sh
app_name=payment
check_rootuser


dnf install python3 gcc python3-devel -y &>>$Logs_file
VALIDATE $? "paython3"

app_setup

cd /app &>>$Logs_file
pip3 install -r requirements.txt &>>$Logs_file
VALIDATE $? "package"

Systemd_setup
Print_Time