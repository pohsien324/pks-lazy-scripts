#!/bin/bash
#-------------------------
#  The easy way to get the BOSH authentication. 
#
#  Last modify: 2019/04/22
#  last modifier: pohsien
#-------------------------
echo -n "Input PCF Ops Manager IP: "
read pcf_ops_manager_ip

read -s -p "Input the password of pcf ops manager admin user: " admin_password

printf "\n"
echo https://$pcf_ops_manager_ip

om --target https://$pcf_ops_manager_ip  -u admin -p $admin_password -k curl -p /api/v0/certificate_authorities -s | jq -r '.certificate_authorities | select(map(.active == true))[0] | .cert_pem' > ~/opsmanager.pem
temp=`om --target https://$pcf_ops_manager_ip  -u admin -p $admin_password -k curl -p /api/v0/deployed/director/credentials/bosh2_commandline_credentials -s | jq -r '.credential' | sed 's\BOSH\export BOSH\g;s\ export\; export\g;s\/var/tempest/workspaces/default/root_ca_certificate\~/opsmanager.pem\g'`
eval $temp
echo $temp | tee set_bosh_env.sh
