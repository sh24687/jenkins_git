FROM ubuntu:20.04

RUN rm -rf /var/lib/apt/lists/* # apt-get update 후, python3 , pip등을 설치
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip