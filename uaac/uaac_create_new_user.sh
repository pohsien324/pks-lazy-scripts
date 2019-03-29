#-------------------------
#  Use UAAC to create PKS user. 
#  https://docs.pivotal.io/runtimes/pks/1-2/manage-users.html#pks-access
# 
#  Last modify: 2019/03/28
#  last modifier: pohsien
#-------------------------
echo -n "Input the hostname of PKS api server(without https://):  "
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

while true; do
    read -p "Add new user to pks admin group (y/n)? " answer
    case $answer in
       [Yy]* ) uaac member add pks.clusters.admin $username; break;;
       [Nn]* ) exit;;
       * ) echo "Please answer yes or no.";;
    esac
done
echo "Complete"
