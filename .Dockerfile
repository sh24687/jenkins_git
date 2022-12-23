# java 11 버전을 사용하겠다는 의미
FROM	openjdk:11

# 해당 이미지를 만든 사용자의 정보
MAINTAINER sh <sh.lee2@chabot.co.kr>

# 도커 컨테이너 호스트와 공유할 디렉터리 지정
VOLUME /build/server

# 도커 이미지를 실행할시 실행될 스크립트
COPY ./start.sh /usr/local/bin
RUN ln -s /usr/local/bin/start.sh /start.sh
CMD ["start.sh"]