mediawiki
=========

Demonstation  of  creation of  Chef   cookbooks  for  a  LAMP  Stack  deployment  in  ami


This cookbook  uses Amazon AWS EC2 linux images with Chef 0.10.0  to create four total CentOS systems running in Amazon EC2.

    1 haproxy software  load balancer.
    2  Media wiki  servers  (  Apache2 web servers running mod_php)
    1 MySQL 5.0   database  server.

The PHP mediaapp used in this guide is MediaWiki 1.18alpha



The mediaapp cookbook will perform the following steps:

    1. Install required packages and pears for the project
    2. set up the deployment scaffolding
    3. creates LocalSettings.php file with the dbserver connection information if required
    4. performs a revision-based deploy
    5. install Apache2 and mod_php
    6. create an mediaapp specific virtual host configuration file.

Environment Setup
=================
Have  your config  file   setup   corectly  
	Knife configuration file (knife.rb)
        validation certificate (thoughtworks-int-validator.pem)
        user certificate (pratikdam.pem) to ~/chef-repo/.chef/. 

Do the  following  steps   to   get  the   config   files  in the     right  directory 

	mkdir ~/mediawiki/.chef
	cp ~/chef-repo/.chef/knife.rb ~/mediawiki/.chef
	cp ~/chef-repo/.chef/USERNAME.pem ~/mediawiki/.chef
	cp ~/chef-repo/.chef/ORGNAME-validator.pem ~/mediawiki/.chef

Add the Amazon AWS credentials to the Knife configuration file.

 Ensure   that   amazon-ec2   can  comunicate   with knife   by   the   settings  in the  ~/mediawiki/.chef/knife.rb


knife[:aws_access_key_id] = "praikdam"
knife[:aws_secret_access_key] =  ""



In addition to the credentials, two additional things need to be configured in the AWS account.Configure the default security group to allow incoming connections for the following ports.

    22 - ssh
    80 - haproxy load balancer
    22002 - haproxy administrative interface
    8080 - apache2 web servers running mod_php


Develop   Cookbooks
==================

The mediawiki also   creates   cookbooks  for  the  sake   of  modularity  .Details   of  the    functions   of  various     cookbooks  are   there  in the  cookbook  README 

	yum
	git
	mysql
	apache2
	haproxy
	mediawiki

Upload all the cookbooks to the Hosted Chef server   using the   command    knife cookbook upload -a

Server Roles
=============
All the required roles have been created in the mediawiki repository. They are in the roles/ directory.

	base.rb
	mediawiki_dbserver_master.rb
	mediawiki.rb
	mediawiki_load_balancer.rb

Upload all the roles to the Hosted Chef server.
rake roles

Data Bag Item
============
The mediawiki repository contains a data bag item that has all the information required to deploy and configure the MediaWiki mediaapp from source using the recipes in the mediaapp and dbserver cookbooks.
The data bag name is apps and the item name is mediawiki. Upload this to the Hosted Chef server.

	knife data bag create apps
	knife data bag from file apps mediawiki.json


Launch  Application
===================

First, launch the dbserver instance.

	1. knife ec2 server create -G default -I ami-e565ba8c  -f m1.micro  -S mediawiki -i ~/.ssh/pratikdam.pem -x centos   -r 'role[base],role[mediawiki_dbserver_master]'

Once the dbserver master is up, launch one node that will create the dbserver schema and set up the dbserver with default data.

	2. knife ec2 server create -G default -I  mi-e565ba8c   -f m1.micro  -S mediawiki -i ~/.ssh/pratikdam.pem -x centos  -r 'role[base],role[mediawiki],recipe[mediawiki::db_bootstrap]' 

Launch the second mediaapp instance w/o the mediawiki::db_bootstrap recipe.

	3. knife ec2 server create -G default -I ami-e565ba8c -f m1.micro  -S mediawiki -i ~/.ssh/pratikdam.pem -x centos   -r 'role[base],role[mediawiki]' 

Once the second mediaapp instance is up, launch the load balancer.

	4. knife ec2 server create -G default -I ami-e565ba8c -f m1.micro -S mediawiki -i ~/.ssh/pratikdam.pem -x centos  -r 'role[base],role[mediawiki_load_balancer]'



Verification
============

Once complete, we would   have four instances running in EC2 with MySQL, MediaWiki and haproxy up and available to serve traffic.
Knife will output the fully qualified domain name of the instance when the commands complete. Navigate to the public fully qualified domain name on port 80.

http://ec2-23-21-19-43.compute-1.amazonaws.com/

The login is admin and the password is mediawiki.

You can access the haproxy admin interface at:

http://ec2-23-21-19-43.compute-1.amazonaws.com:22002/
