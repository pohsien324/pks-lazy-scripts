#-------------------------
#  The easy way to get the BOSH authentication. 
#
#  Last modify: 2019/03/28
#  last modifier: pohsien
#-------------------------
echo -n "Input PCF Ops Manager IP: "
read pcf_ops_manager_ip

read -s -p "Input the password of pcf ops manager admin user: " admin_password

printf "\n"
echo https://$pcf_ops_manager_ip

om --target https://$pcf_ops_manager_ip  -u admin -p $admin_password -k curl -p /api/v0/certificate_authorities -s | jq -r '.certificate_authorities | select(map(.active == true))[0] | .cert_pem' > /root/opsmanager.pem
temp=`om --target https://$pcf_ops_manager_ip  -u admin -p $admin_password -k curl -p /api/v0/deployed/director/credentials/bosh2_commandline_credentials -s | jq -r '.credential' | sed 's\BOSH\export BOSH\g;s\ export\; export\g;s\/var/tempest/workspaces/default/root_ca_certificate\/root/opsmanager.pem\g'`
eval $temp
echo $temp | tee new_bosh_env.sh
