#!/bin/bash

echo "Welcome to roachKit, the easy way to start and connect cockroachdb servers";
echo "roachKit uses default ports";
echo "";
echo "1: Start Node [Secure] [Standalone]";
echo "2: Start Node [Secure [Join]]";
echo "3: Create Base Certs [CA,root user,host]";
echo "4: Stop Node [Secure]";
echo "5: Install cockroachdb";
echo "6: Create user cert";
echo "7: SQL connect [SECURE]";
read option;

#start server
if [ $option == '1' ]
then
echo "Certs dir -->";
read crtdir;
echo "Hostname -->";
read hostname;
cockroach start --host=$hostname --certs-dir=$crtdir &
#join node
elif [ $option == '2' ]
then
echo "Certs dir -->";
read crtdir;
echo "Local hostname -->";
read lhost;
echo "Remote hostnme -->";
read rhost;
cockroach start --host=$lhots --join=$rhost:26257 --certs-dir=$crtdir &
#create certs
elif [ $option == '3' ]
then
mkdir certs
mkdir dir-safe
echo "Creating base CA";
cockroach cert create-ca --certs-dir=certs --ca-key=dir-safe/ca.key
echo "Creating root user CA";
cockroach cert create-client root --certs-dir=certs --ca-key=dir-safe/ca.key
echo "Creating host CA";
echo "Enter hostname -->";
read lhost
cockroach cert create-node $lhost --certs-dir=certs --ca-key=dir-safe/ca.key
#exit server
elif [ $option == '4' ]
then
echo "Certs dir -->";
read crtdir;
echo "Hostname -->";
read hostname;
cockroach quit --host=$hostname --certs-dir=$crtdir;
#install
elif [ $option == '5' ]
then
wget -o- https://binaries.cockroachdb.com/cockroach-v1.0.2.linux-amd64.tgz
tar xfz cockroach-v1.0.2.linux-amd64.tgz
cp -i cockroach-v1.0.2.linux-amd64/cockroach /usr/local/bin
#user key
cockroach version
elif [ $option == '6' ]
then
echo "Username -->";
read username;
echo "CA.key -->";
read key
echo "Certs dir -->";
read certs

cockroach cert create-client $username --certs-dir=$certs --ca-key=$key
#sql conenct
elif [ $option == '7' ]
then
echo "RHOST -->";
read rhost
echo "Certs Dir -->";
read certs
echo "User -->"
read user;
cockroach sql --certs-dir=$certs --host=$rhost --user=$user
fi
