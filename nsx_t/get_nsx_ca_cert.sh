#!/bin/bash
#-------------------------
#  Get the NSX-T CA cert when BOSH installation. 
#  https://docs.pivotal.io/runtimes/pks/1-2/generate-nsx-ca-cert.html
#
#  Last modify: 2019/04/22
#  last modifier: pohsien
#-------------------------

echo -n "Input the NSX-MANAGER FQDN: "
read nsx_manager_hostname

echo -n "Input the NSX-MANAGER IP: "
read nsx_manager_ip

echo "[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
prompt = no
[ req_distinguished_name ]
countryName = US
stateOrProvinceName = California
localityName = Palo-Alto
organizationName = NSX
commonName = $nsx_manager_hostname
[ req_ext ]
subjectAltName=DNS:$nsx_manager_hostname,$nsx_manager_ip" > nsx-cert.cnf

export NSX_MANAGER_IP_ADDRESS=$nsx_manager_ip
export NSX_MANAGER_COMMONNAME=$nsx_manager_hostname

openssl req -newkey rsa:2048 -x509 -nodes \
-keyout nsx.key -new -out nsx.crt -subj /CN=$NSX_MANAGER_COMMONNAME \
-reqexts SAN -extensions SAN -config <(cat ./nsx-cert.cnf \
 <(printf "[SAN]\nsubjectAltName=DNS:$NSX_MANAGER_COMMONNAME,IP:$NSX_MANAGER_IP_ADDRESS")) -sha256 -days 730
openssl x509 -in nsx.crt -text -noout

cat nsx.crt
printf "\n\n"
cat nsx.key
printf "\n\n"

echo "nsx.crt and nsx.key have created, please import these two files into nsx-t manager."
read -p "If complete, press [Enter] to continue"


sudo apt install jq -y

read -s -p "Input NSX-MANAGER admin password: " nsx_manager_password
printf "\n"

echo -n "Input the certificate name: "
read certificate_name

id=`curl --insecure -u admin:"$nsx_manager_password" -X \
GET "https://$nsx_manager_ip/api/v1/trust-management/certificates" \
| jq -r --arg certificate_name "$certificate_name" '.results[] | select(.display_name == $certificate_name) | .id'`
echo $id

curl --insecure -u admin:"$nsx_manager_password" -X \
POST "https://$NSX_MANAGER_IP_ADDRESS/api/v1/node/services/http?action=apply_certificate&certificate_id=$id"
echo "Complete"
