#!/usr/bin/env bash

REPOSITORY=/home/ubuntu/build
cd $REPOSITORY

BUILD_JAR=$(ls /home/ubuntu/build/libs/*.jar)
JAR_NAME=$(ls $REPOSITORY/build/libs/ | grep '.jar' | tail -n 1)
JAR_PATH=$REPOSITORY/build/libs/$JAR_NAME
echo "> build 파일명: $JAR_NAME" >> /home/ubuntu/action/deploy.log

echo "> build 파일 복사" >> /home/ubuntu/mash/deploy.log
DEPLOY_PATH=/ubuntu/ec2-user/mash/
cp $BUILD_JAR $DEPLOY_PATH

echo "> 현재 실행중인 애플리케이션 pid 확인" >> /home/ubuntu/build/deploy.log
CURRENT_PID=$(pgrep -f $APP_NAME)

if [ -z $CURRENT_PID ]
then
  echo "> 종료할것 없음." >> /home/ubuntu/mash/deploy.log
else
  echo "> kill -9 $CURRENT_PID"
  kill -9 $CURRENT_PID
  sleep 5
fi

DEPLOY_JAR=$DEPLOY_PATH
echo "> DEPLOY_PATH 배포"  >> /home/ubuntu/mash/deploy.log
nohup java -jar -Dspring.profiles.active=prod $JAR_PATH > /dev/null 2> /dev/null < /dev/null &
nohup java -jar $DEPLOY_JAR >> /home/ubuntu/deploy.log 2> /home/ubuntu/mash/deploy_err.log &

echo "[$(date)] server deploy" >> /home/ubuntu/deploy.log
