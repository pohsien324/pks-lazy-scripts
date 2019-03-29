#-------------------------
#  Import the superuser certificate into NSX-T when PKS installation.
#  https://docs.pivotal.io/runtimes/pks/1-3/generate-nsx-pi-cert.html
# 
#  Last modify: 2019/03/28
#  last modifier: pohsien
#-------------------------

if [ -f "./pks-nsx-t-superuser.crt" ] && [ -f "./pks-nsx-t-superuser.key" ]
then
  sudo apt install jq -y
  echo -n "Input NSX_MANAGER IP: "
  read nsx_manager

  echo -n "Input NSX_USER: "
  read nsx_user


  read -s -p "Input NSX_PASSWORD: " nsx_password
  printf "\n"


  export NSX_MANAGER="$nsx_manager"
  export NSX_USER="$nsx_user"
  export NSX_PASSWORD="$nsx_password"
  export PI_NAME="pks-nsx-t-superuser"
  export NSX_SUPERUSER_CERT_FILE="pks-nsx-t-superuser.crt"
  export NSX_SUPERUSER_KEY_FILE="pks-nsx-t-superuser.key"
  export NODE_ID=$(cat /proc/sys/kernel/random/uuid)


cert_request=$(cat <<END
  {
    "display_name": "$PI_NAME",
    "pem_encoded": "$(awk '{printf "%s\\n", $0}' $NSX_SUPERUSER_CERT_FILE)"
  }
END
)

id=`curl -k -X POST \
"https://${NSX_MANAGER}/api/v1/trust-management/certificates?action=import" \
-u "$NSX_USER:$NSX_PASSWORD" \
-H 'content-type: application/json' \
-d "$cert_request"  | grep \"id\" | awk '{print $3}' | sed 's/[\",]//g'`

printf "\n\n"
echo "id=$id"
export CERTIFICATE_ID="$id"

pi_request=$(cat <<END
  {
    "display_name": "$PI_NAME",
    "name": "$PI_NAME",
    "permission_group": "superusers",
    "certificate_id": "$CERTIFICATE_ID",
    "node_id": "$NODE_ID"
  }
END
)

curl -k -X POST \
  "https://${NSX_MANAGER}/api/v1/trust-management/principal-identities" \
  -u "$NSX_USER:$NSX_PASSWORD" \
  -H 'content-type: application/json' \
  -d "$pi_request"

else
  echo "Please create pks-nsx-t-superuser.crt and pks-nsx-t-superuser.key."
fi
