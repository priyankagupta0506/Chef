#!/bin/bash

#ssh -i "jenkins" priyankagu@localhost
free -m 
echo "memory check"
netstat -anltp | grep 8080
echo "jenkins check"
