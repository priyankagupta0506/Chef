#!/bin/bash
scp -i ~/.ssh/mysql.pem /home/priyankagu/Desktop/pos.sh ubuntu@Master_DNS:/home/ubuntu
pos=$(ssh -i ~/.ssh/mysql.pem ubuntu@Master_DNS "chmod 755 pos.sh | ./pos.sh")
echo $pos
