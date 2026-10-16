#!/bin/bash

IP="34.241.135.219"

#copy private key to terraform code
cp ~/.ssh/id_rsa.pub terraform/key.pub

#copy private key to public vm to access private vm
#scp /home/ec2-user/.ssh/id_rsa ec2-user@"$IP":/home/ec2-user/.ssh/id_rsa

#copy ansible to controller vm
#scp -r ansible/ ec2-user@"$IP":/home/ec2-user/
#scp -r scripts/ ec2-user@"$IP":/home/ec2-user/
#ssh "$IP" "sudo yum install ansible -y"

echo "end"
