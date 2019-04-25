#!/bin/bash
#-------------------------
#  The easy way to operate BOSH functions. 
#
#  Last modify: 2019/04/22
#  last modifier: pohsien
#-------------------------

while true; do
   printf "\n"
   deployment_array=( $(bosh deployments | awk '{print $1}' | grep 'harbor\-container\-registry\-\|pivotal\-container\-service\-\|service-instance_') )
   echo "--------------------------------"
   echo "Deployments:"
   for i in $(seq 0 $((${#deployment_array[@]}-1)));
   do
        echo "$((i+1))) ${deployment_array[$i]}"
   done
   echo "------------------------------"

   echo -n "Choose the deployment: "
   read deployment_choice


   vm_array=( $(bosh -d ${deployment_array[$((deployment_choice -1))]} vms | awk '{print $1}') )


   printf "\nWork:\n"
   echo "1) Show task"
   echo "2) Delete Deployment"

   # Check if there is any VM in this deployment ?
   if [ ${#vm_array[@]} -gt 0 ]
   then
        echo "3) VM status"
        echo "4) SSH"
        echo "5) Delete VM"
   fi

   echo -n "What do you want to do: "
   read answer
   case $answer in
     1 ) # Show Deployment's Task

        # Command
        bosh -d ${deployment_array[$((deployment_choice -1))]} task ;;
     2 ) # Delete Deployment

        # Command
        bosh -d ${deployment_array[$((deployment_choice -1))]} delete-deployment ;;
     3 ) # Show VM Status
        if [ ${#vm_array[@]} -eq 0 ]
        then
                break
        fi

        # Command
        bosh -d ${deployment_array[$((deployment_choice -1))]} vms ;;
     4 ) # SSH
        if [ ${#vm_array[@]} -eq 0 ]
        then
                break
        fi

        printf "\nVM list:\n"
        for i in $(seq 0 $((${#vm_array[@]}-1)));
        do
           echo "$((i+1))) ${vm_array[$i]}"
        done

        printf "\n"
        echo -n "Choose the vm: "
        read vm_choice

        # Command
        bosh -d ${deployment_array[$((deployment_choice -1))]} ssh ${vm_array[$((vm_choice - 1))]}
        ;;
     5 ) # Delete VM
        printf "\nVM list:\n"
        if [ ${#vm_array[@]} -eq 0 ]
        then
                break
        fi

        for i in $(seq 0 $((${#vm_array[@]}-1)));
        do
           echo "$((i+1))) ${vm_array[$i]}"
        done

        printf "\n"
        echo -n "Choose the vm: "
        read vm_choice

        # Command
        bosh -d ${deployment_array[$((deployment_choice -1))]} delete-vm ${vm_array[$((vm_choice -1))]}
        ;;
    * ) echo "Please choice the correct number." ;;
   esac
done
