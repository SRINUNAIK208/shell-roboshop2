#!/bin/bash
start_Data=$(data +%s)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Logs_Folder="/var/log/shellscript-log"
Script_Name="$(echo $0 | cut -d "." -f1)"
Logs_file="$Logs_Folder/$Script_Name.log"

Script_Dir=$PWD

mkdir -p $Logs_Folder


UserId=$(id -u) &>>$Logs_file

check_rootuser(){

  if [ $UserId -eq 0 ]
  then 
    echo -e "$G user running the script with root access $N" &>>$Logs_file
  else
    echo -e "$R user not running the script with root access $N" &>>$Logs_file
    exit 1
  fi

}

VALIDATE(){
    
    if [ $1 -eq 0 ]
    then
       echo -e " $2 installation... $G success $N" &>>$Logs_file
    else
       echo -e " $2 installation...$R failure $N" &>>$Logs_file
       exit 1
    fi

}
Nodejs_setup(){

    dnf module disable nodejs -y &>>$Logs_file
    VALIDATE $? "Disabled nodejs"

   dnf module enable nodejs:20 -y &>>$Logs_file
   VALIDATE $? "Enabled nodejs"

   dnf install nodejs -y &>>$Logs_file
   VALIDATE $? "Installed nodejs"

   npm install &>>$Logs_file
   VALIDATE $? "installed package"
}
app_setup(){
    
   id roboshop &>>$Logs_file
    if [ $? -eq 0 ]
    then
      echo "roboshop user already created...Nothing to do" &>>$Logs_file
    else
      useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$Logs_file
      VALIDATE $? "Created roboshop system user"
    fi

   mkdir -p /app &>>$Logs_file
   curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$Logs_file
   VALIDATE $? "download roboshop artifact"

   cd /app
   unzip /tmp/$app_name.zip &>>$Logs_file
   VALIDATE $? "unzip artifact"

}
Systemd_setup(){
    
   cp $Script_Dir/$app_name.service /etc/systemd/system/$app_name.service &>>$Logs_file
   VALIDATE $? "copy $app_name service"

   systemctl daemon-reload &>>$Logs_file
   systemctl enable $app_name &>>$Logs_file
   systemctl start $app_name &>>$Logs_file
   VALIDATE $? "started calalogue"
}
redis_setup(){
    dnf module disable redis -y &>>$Logs_file
    dnf module enable redis:7 -y &>>$Logs_file
    VALIDATE $? "Enables redis"

    dnf install redis -y &>>$Logs_file
    VALIDATE $? "redis"
}

Print_Time(){
    End_Date=$(date +%s)
    Total_Time=$(($End_Date-$start_Data))
    echo -e "Script executed successfully, $Y Time Taken:: $Total_Time seconds $N"
}
