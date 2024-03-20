#!/bin/bash

green_echo() {
  echo -e "\e[32m$1\e[0m"
}

#-----------------------------------------
# Updating and upgrading the Ubuntu server
#-----------------------------------------
green_echo "Updating and upgrading the Ubuntu server"
sudo apt-get update
sudo apt-get upgrade -y

#-------------------
# Installing unzip
#-------------------
green_echo "Installing unzip"
sudo apt-get install unzip

#-------------------
# Installing Terraform
#-------------------
green_echo "Installing Terraform"
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install terraform

#-------------------
# Installing kubectl
#-------------------
green_echo "Installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

chmod +x kubectl 
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

#-------------------
# Installing AWS CL
#-------------------
green_echo "Installing AWS CL"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install --update

#-------------------
# Installing Helm
#-------------------
green_echo "Installing Helm"
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

sudo apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update

sudo apt-get install helm

#-------------------
# Installing Jenkins
#-------------------
green_echo "Installing Jenkins"
sudo apt-get update

sudo apt install openjdk-11-jre -y

java -version

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

green_echo "updating systems..."
sudo apt-get update

sudo apt-get install jenkins -y

#--------------------------------
# Enable and Start Jenkins Server
#--------------------------------
green_echo "enabling and starting jenkins server..."
sudo systemctl enable jenkins

sudo systemctl start jenkins

sudo systemctl status jenkins

#-------------------------
# Open and Enable Firewall
#-------------------------
green_echo "opening ports and enabling firewall..."
sudo ufw allow OpenSSH 

sudo ufw enable

sudo ufw allow 8080

sudo ufw status

green_echo "script is done running"