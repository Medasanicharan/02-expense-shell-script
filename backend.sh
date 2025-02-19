#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "please run this script with root access"
    exit 1
else
    echo "you are super user"
fi

SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%F-%H-%M-%S) # TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log # LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

echo "please enter DB password:"
read mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Creating expense project"
else
    echo -e "expense user already created.. $Y SKIPPING $n"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code"

cd /app &>>$LOGFILE
VALIDATE $? "open the app"

unzip /tmp/backend.zip
VALIDATE $? "Extract backend code"

npm install &>>$LOGFILE
VALIDATE $? "Intalling nodejs dependencies"

# cp /home/ec2-user/02-expense-shell-script/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
# VALIDATE $? "copied backend service"

# systemctl daemon-reload &>>$LOGFILE
# VALIDATE $? "Demon reload"

# systemctl start backend &>>$LOGFILE
# VALIDATE $? "Starting bacend"

# systemctl enable backend &>>$LOGFILE
# VALIDATE $? "Enabling backend"

# dnf install mysql -y &>>$LOGFILE
# VALIDATE $? "Installing MySQL"

# mysql -h db.daws78s.xyz -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
# VALIDATE $? "Schema loading"

# systemctl restart backend &>>$LOGFILE
# VALIDATE $? "Restarting backend"