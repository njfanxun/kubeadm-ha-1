#!/bin/bash

apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
sudo apt-get install git python2.7 python-pip sshpass -y
sudo pip install pip --upgrade -i https://mirrors.aliyun.com/pypi/simple/
sudo pip install --no-cache-dir ansible==2.7.5 netaddr -i https://mirrors.aliyun.com/pypi/simple/