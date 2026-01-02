#!/bin/bash
start_Data=$(date +%s)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Logs_Folder="/var/log/shellscript-log"
Script_Name="$(echo $0 | cut -d "." -f1)"
Logs_file="$Logs_Folder/$Script_Name.log"

Script_Dir=$PWD

mkdir -p $Logs_Folder


UserId=$(id -u) 

check_rootuser(){

  if [ $UserId -eq 0 ]
  then 
    echo -e "$G user running the script with root access $N" 
  else
    echo -e "$R user not running the script with root access $N" 
    exit 1
  fi

}

VALIDATE(){
    
    if [ $1 -eq 0 ]
    then
       echo -e " $2 installation... $G success $N" 
    else
       echo -e " $2 installation...$R failure $N" 
       exit 1
    fi

}
Nodejs_setup(){

    dnf module disable nodejs -y 
    VALIDATE $? "Disabled nodejs"

   dnf module enable nodejs:20 -y 
   VALIDATE $? "Enabled nodejs"

   dnf install nodejs -y 
   VALIDATE $? "Installed nodejs"

   npm install 
   VALIDATE $? "installed package"
}
app_setup(){
    
   id roboshop 
    if [ $? -eq 0 ]
    then
      echo "roboshop user already created...Nothing to do" 
    else
      useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop 
      VALIDATE $? "Created roboshop system user"
    fi

   mkdir -p /app 
   curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip 
   VALIDATE $? "download roboshop artifact"

   cd /app
   unzip /tmp/$app_name.zip 
   VALIDATE $? "unzip artifact"

}
Systemd_setup(){
    
   cp $Script_Dir/$app_name.service /etc/systemd/system/$app_name.service 
   VALIDATE $? "copy $app_name service"

   systemctl daemon-reload 
   systemctl enable $app_name 
   systemctl start $app_name 
   VALIDATE $? "started calalogue"
}
redis_setup(){
    dnf module disable redis -y 
    dnf module enable redis:7 -y 
    VALIDATE $? "Enables redis"

    dnf install redis -y 
    VALIDATE $? "redis"
}

Print_Time(){
    End_Date=$(date +%s)
    Total_Time=$(($End_Date-$start_Data))
    echo -e "Script executed successfully, $Y Time Taken:: $Total_Time seconds $N"
}
