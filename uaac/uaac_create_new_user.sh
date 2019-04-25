#!/bin/bash
#-------------------------
#  Use UAAC to create PKS user. 
#  https://docs.pivotal.io/runtimes/pks/1-2/manage-users.html#pks-access
# 
#  Last modify: 2019/04/22
#  last modifier: pohsien
#-------------------------
echo -n "Input the FQDN of PKS api server (without https://):  "
read api_server

uaac target https://$api_server:8443 --skip-ssl-validation

echo -n "Press the secret of the Pks Uaa Management Admin Client: "
read token

uaac token client get admin -s $token

echo -n "New user: "
read username

echo -n "Email of new user: "
read email

read -s -p "Password of new user: " password
printf "\n"

uaac user add $username --emails $email -p $password

printf "\nPKS user privileges: \n"
   echo "1) pks.clusters.admin"
   echo "2) pks.clusters.manage"

while true; do
    echo -n "Choose the privilege of this user: "
    read answer
    case $answer in
       1 ) uaac member add pks.clusters.admin $username; break;;
       2 ) uaac member add pks.clusters.manage $username; break;;
       * ) echo "Please choose the valid number.";;
    esac
done
printf "\nComplete.\n\nUse the following command to log in to PKS:\n$ pks login -a $api_server -u $username -k\n"
