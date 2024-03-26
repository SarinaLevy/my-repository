#!/bin/bash
# Make sure you are the root user, if not switch to root user
sudu su
#update the OS
yum update -y
#Then install Apache
yum install httpd -y
#(in a seperate terminal)Then we pull code/ get the web content onto our Ec2 instance from a github repository by cd into the file. Then running the following commands
