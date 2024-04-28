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
git add .
git commit -m " add whatever you updated here"
git push
#You can check for the upate by looking into the repositry and looking and the raw code and seeing the change there
#now to update the files on the ec2 instance. run the following
cd /var/www/html
ls -l # to see the files. so instead of pulling the updated file just remove it by running the following command
rm -f index.html # it means remove by force
#then run the following because its the update version of what you just removed
wget ${FOLDER}/index.html # run ls -l to see the updated file has been added
# Now create a new instance to add the script we created to run it

#Note to self The following lines below from 67-85 we add to the user data in the new instance

#!/bin/bash

# update the OS
yum update -y

#install Apache
yum install httpd -y

# copy content to /var/www/html folder
cd /var/www/html

FOLDER="https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web"
wget ${FOLDER}/index.html
wget ${FOLDER}/cat0.jpg
wget ${FOLDER}/cat1.jpg
wget ${FOLDER}/cat2.jpg

#Now we start and enable Apache service by running the follwing commands
systemctl start httpd
systemctl enable httpd

#NOTE TO SELF THIS IS PART 2 IN NEW FOLDER WITH NEW SCRIPT
#Then open new file in Visual code in yaml and run the
cfn lite 
#then go to google and type in amazon security group or follow link
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-securitygroup.html
#copy the yaml and copy to your new script, then customize as needed
#Then go back to the website on line 92 and click on the word Ingress and scroll down to get the rules (which is the inbound rules)
  rSecGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow SSH and HTTP from Internet
      GroupName: SSHandHTTP
      SecurityGroupIngress: 
        - CidrIp: 0.0.0.0/0
          FromPort: 22
          ToPort: 22
          IpProtocol: tcp
        - CidrIp: 0.0.0.0/0
          FromPort: 80
          ToPort: 80
          IpProtocol: tcp
      Tags: 
        - Key: Name
          Value: KittensSecGroup
        - Key: Company
          Value: Clarusway
#Now we need to build the EC2 instance, so go to google and type in aws cloud formation EC2 instance or follow the link below and click on yaml to get the rules needed and customize as needed
#https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-instance.html
  rWebServer:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !Ref pImageId
      InstanceType: t2.micro
      KeyName: !Ref pKeyname
      SecurityGroupIds: 
        - !Ref rSecGroup
      Tags: 
        - Key: Name
          Value: Kittens Web Server
      UserData: !Base64 |
#Then go to aws cloud formation parameters or follow link below
#https://us-east-1.console.aws.amazon.com/systems-manager/parameters/?region=us-east-1&tab=PublicTable#public_parameter_service=ami-amazon-linux-latest&public_parameter_filters=6.1
#We ended up using the code snipet and we just typed in parameter and selected the first one
  pKeyname:
    Description: Key name for EC2 access
    Type: AWS::EC2::KeyPair::KeyName
#Then go to amazon console, type in system manager, then type in parameter store 
#When complete add the script you created, it should look like the following (check tabs)

AWSTemplateFormatVersion: 2010-09-09
Description: |
  EC2 instance and SG for kittens carousel website
  
Parameters:

  pKeyname:
    Description: Key name for EC2 access
    Type: AWS::EC2::KeyPair::KeyName

  pImageId:
    Description: Latest Linux AMI
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64

Resources:

  rSecGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Allow SSH and HTTP from Internet
      GroupName: SSHandHTTP
      SecurityGroupIngress: 
        - CidrIp: 0.0.0.0/0
          FromPort: 22
          ToPort: 22
          IpProtocol: tcp
        - CidrIp: 0.0.0.0/0
          FromPort: 80
          ToPort: 80
          IpProtocol: tcp
      Tags: 
        - Key: Name
          Value: KittensSecGroup
        - Key: Company
          Value: Clarusway

  rWebServer:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !Ref pImageId
      InstanceType: t2.micro
      KeyName: !Ref pKeyname
      SecurityGroupIds: 
        - !Ref rSecGroup
      Tags: 
        - Key: Name
          Value: Kittens Web Server
      UserData: !Base64 |
        #!/bin/bash -x #

        # update the OS
        yum update -y

        #install Apache
        yum install httpd -y

        # copy content to /var/www/html folder
        cd /var/www/html
        FOLDER="https://raw.githubusercontent.com/SarinaLevy/my-repository/main/101-kittens-carousel-static-website-ec2/static-web"
        wget ${FOLDER}/index.html
        wget ${FOLDER}/cat0.jpg
        wget ${FOLDER}/cat1.jpg
        wget ${FOLDER}/cat2.jpg

        # start and enable Apache service
        systemctl start httpd
        systemctl enable httpd  

#Now go to Cloud formation in amazon, click create stack, chose template is ready, upload template file,Chose the yaml file just created under my repository,click next
#Now enter stack name,chose keypair name, click next
#Now leave the configure page as is, click next
#Now review, click submit
#Then go to stack info, go to resources, click on the instance,(rWebServer)
#Then select the public Ipv4 (and hopefully we have a working webserver)