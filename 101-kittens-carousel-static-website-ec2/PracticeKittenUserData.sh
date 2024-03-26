#!/bin/bash
# Make sure you are the root user, if not switch to root user
sudu su
#update the OS
yum update -y
#Then install Apache
yum install httpd -y
#(in a seperate terminal)Then we pull code/ get the web content onto our Ec2 instance from a github repository by cd into the file. Then running the following commands
cd 101-kittens-carousel-static-website-ec2/
#then run these following commands
git add .
git commit -m "add a message here"
git push
# NOTE TO SELF THE FOLLOWING IS GOING TO LOOK SUPER REPETATIVE;SO JUST READ LINES 15-38; BUT WHEN YOU ARE READY YOU ARE GOING TO RUN LINES 39-44
#then go to git rep, my repository and see the file you just pushed into your git hub
#then go into it and click on static web
#then click on the file you want
#click raw and copy the http url and add the wget command
wget https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web/index.html
#But before we run wget to get the file above, we have to copy the content for apache into a folder called var by using the following command first
cd /var/www/html
#so to copy the content
#first
cd /var/www/html
#then
wget https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web/index.html
#however because we have a few folders to get we are going to assign it to a variable
#so under the cd /var/www/html we add the variabel (ex:below) you can run the pwd command if you want to make sure you are in the /var folder
cd /var/www/html
FOLDER="https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web"
wget ${FOLDER}/index.html
#then run the ls command to see the file has been copied from the git repo to the instane
#then get the other file we need from the git repo by running the following commands
wget ${FOLDER}/cat0.jpg
wget ${FOLDER}/cat1.jpg
wget ${FOLDER}/cat2.jpg
#then run ls -l to see the files
#so technically we are running the following commands back to back
cd /var/www/html
FOLDER="https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web"
wget ${FOLDER}/index.html
wget ${FOLDER}/cat0.jpg
wget ${FOLDER}/cat1.jpg
wget ${FOLDER}/cat2.jpg
#Now we start and enable Apache service by running the follwing commands
systemctl start httpd
systemctl enable httpd
systemctl status httpd # will show that it is active ave and running
#Then press q to get back
#then to check it so far, you go to the EC2 instance and click on the Ipv4 (make sure it says http and not https)
#from here we went to the static web folder and clicked the index.html file and looked for where it said Student_name and change to whateever name you need. Which was line 48 and 83
#now we get it onto our ec2 instance, by pushing it to our github