#-------------------------
#  Setting the NSX-T Management-Cluster and Control-Cluster. 
#  https://docs.pivotal.io/runtimes/pks/1-2/nsxt-prepare-env.html#nsx-clusters
#
#  Last modify: 2019/03/28
#  last modifier: pohsien
#-------------------------

ssh-keygen
# Add ssh key to NSX-T manager
echo -n "Please input the NSX-T manager IP: "
read manager

ssh-copy-id -i ~/.ssh/id_rsa.pub root@$manager
ssh root@$manager 'cp ~/.ssh/authorized_keys /home/admin/.ssh/authorized_keys ; chmod +r /home/admin/.ssh/authorized_keys'

# Add ssh key to NSX-T controller
echo -n "Please input the number of NSX-T controller: "
read number_controller


for i in $(seq 1 $number_controller);
do
   echo -n "Please input the NSX-T controller $i IP: "
   read controller[$i]
   ssh-copy-id -i ~/.ssh/id_rsa.pub root@${controller[$i]}
   ssh root@${controller[$i]} 'cp ~/.ssh/authorized_keys /home/admin/.ssh/authorized_keys ; chmod +r /home/admin/.ssh/authorized_keys'
done


#-----------Management Cluster-----------------

printf "Configuring Management Cluster...\n"
ssh admin@$manager 'get certificate api thumbprint' > manager_thumbprint.txt
manager_thumnbprint=`cat manager_thumbprint.txt`

for i in $(seq 1 $number_controller);
do 
	ssh admin@${controller[$i]} "join management-plane $manager username admin thumbprint $manager_thumnbprint"
	echo "NSX-T controller $i join the management cluster"
done

printf "\n\n"
echo "------------------------Management-Cluster Status-------------------"
ssh admin@$manager 'get management-cluster status'
echo "-----------------------------------------------------------------------"


read -p "Press [Enter] to continue"
printf "\n\n"
#-------------------------Control Cluster------------------
printf "Configuring Control Cluster...\n"
echo -n "Please input the shared-secret: "
read secret

# initialize control-cluster
ssh admin@${controller[1]} << EOF
set control-cluster security-model shared-secret secret $secret
initialize control-cluster
EOF

# join to control-cluster
for i in $(seq 1 $number_controller);
do
	ssh admin@${controller[$i]} "set control-cluster security-model shared-secret secret $secret"
	ssh admin@${controller[$i]} 'get control-cluster certificate thumbprint' > control_thumbprint.txt

	control_thumbprint=`cat control_thumbprint.txt`
        ssh admin@${controller[1]} "join control-cluster ${controller[$i]} thumbprint $control_thumbprint"

        ssh admin@${controller[$i]} 'activate control-cluster'
	echo "NSX-T controller $i join the control cluster"
done


printf "\n\n"
echo "----------------------Control-Cluster Status-------------------"
ssh admin@${controller[1]} 'get control-cluster status'
echo "-----------------------------------------------------------------------"