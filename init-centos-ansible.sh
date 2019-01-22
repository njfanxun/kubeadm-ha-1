#!/bin/bash

sudo yum install epel-release -y 
sudo yum install git python sshpass python-pip -y
sudo pip install pip --upgrade -i https://mirrors.aliyun.com/pypi/simple/
sudo pip install --no-cache-dir ansible==2.7.5 netaddr -i https://mirrors.aliyun.com/pypi/simple/