#-------------------------
#  The easy way to ssh into BOSH Director VM. 
# 
#  Last modify: 2019/03/28
#  last modifier: pohsien
#-------------------------

clear
echo "------------------------------------"
echo "  1) Configure the BOSH ssh private  key "
echo "  2) SSH to BOSH director VM "
echo "-------------------------------------"

while true; do
   read -p "Choose your option: " answer
   case $answer in
      1 )
          echo "# Press  the Bbr SSH Credentials" > ~/.ssh/bbr.key
          echo "# https://<ops_manager_ip>/api/v0/deployed/director/credentials/bbr_ssh_credentials" >>  ~/.ssh/bbr.key
          echo "# Remove above two lines after you press the key" >> ~/.ssh/bbr.key
          vim ~/.ssh/bbr.key
          sed -i 's/\\n/\n/g' ~/.ssh/bbr.key
          chmod 600 ~/.ssh/bbr.key
          echo "Complete"
              ;;
      2 )
          echo -n "Input the BOSH director IP: "
          read bosh_ip
          ssh bbr@$bosh_ip  -i  ~/.ssh/bbr.key
          break
              ;;
      * ) echo "Please answer 1 or 2." ;;
   esac
done
