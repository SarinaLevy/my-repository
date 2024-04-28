#!/bin/bash

sudo su
yum update -y
yum install httpd -y

cd https://github.com/SarinaLevy/my-repository.git
FOLDER="
