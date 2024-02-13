#!/bin/bash

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt-get install openjdk-17-jdk -y
sudo apt install jenkins -y

# Install efs-utils
apt-get install awscli -y
mkdir /var/lib/jenkins/efs
sudo apt-get -y install git binutils
git clone https://github.com/aws/efs-utils
cd /efs-utils
./build-deb.sh
apt-get -y install ./build/amazon-efs-utils*deb

# Mount EFS
fsname=$(aws efs describe-file-systems --region us-east-1 --creation-token jenkins-agents --output table |grep FileSystemId |awk '{print $(NF-1)}')
mount -t efs $fsname /var/lib/jenkins/efs
chown jenkins:jenkins /var/lib/jenkins/efs

