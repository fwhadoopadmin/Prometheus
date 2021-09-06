#!/bin/bash

# Installing node_exporter in Centos7 
# Author: meme 
##################################################

# requirements:
# This file {set_node_exporter_service.sh} needs to be in the same working directory before you execute the script ---
# #sudo systemctl daemon-reload; sudo systemctl start node_exporter; Sudo systemctl status node_exporter; sudo systemctl enable node_exporter


set -eu 



function  users() {

username=$(cat /etc/passwd |grep -i node_exporter| awk '{print $1}'|cut -d ":" -f1| wc -l)

if [ $username == 0 ]; then
        useradd --no-create-home node_exporter;
fi
}


function install_node_exporter() {

tarfile="https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz"
zipfile="node_exporter-1.2.2.linux-amd64.tar.gz"

wget $tarfile;
sleep 2
tar -xvf ${zipfile} ;
sleep 2

yes| sudo cp -r  node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
yes| sudo cp -r  node_exporter-1.2.2.linux-amd64/node_exporter   /usr/sbin/

}

function  set_dirs() {

 dirname="/etc/prometheus"
 file="prometheus.yml"
 filename="${dirname}/${file}"

 if [ ! -d $dirname ] 2>/dev/null; then
        mkdir -p $dirname
 fi

 if [ ! -f $filename ] 2>/dev/null; then
        touch $filename
 fi

}


function sets_yaml_mainfile() {

 dirname="/etc/prometheus"
 file="prometheus.yml"
 filename="${dirname}/${file}"


 if [ -f $filename ]; then
   (cat <<- _EOF_
        global:
          scrape_interval: 15s

        scrape_configs:
        - job_name: node
          static_configs:
          - targets: ['localhost:9100']
        _EOF_
        ) > $filename && ls -ltr $filename && cat $filename
 fi

}

function set_exporter(){
echo " This file {set_node_exporter_service.sh} needs to be in the same working directory before you execute the script ---> "

filename="set_node_exporter_service.sh"

if [ -f $filename ]; then
         echo "setting -exporter-service file --> ";
        ./set_node_exporter_service.sh
        sleep 2;
fi

}

function  set_perms() {
#username=$(cat /etc/passwd |grep -i node_exporter| awk '{print $1}'|cut -d ":" -f1| wc -l)

if [ $username == 0 ]; then
        useradd --no-create-home node_exporter;
fi
leep 2;

chown -R node_exporter:node_exporter /etc/prometheus*
chown node_exporter:node_exporter /usr/local/bin/node_exporter*
chown -R node_exporter:node_exporter    /etc/systemd/system/node_exporter.service
chown -R node_exporter:node_exporter /usr/sbin/node_exporter
echo " REloading systemd services --> "
firewall-cmd --zone=public --add-port=9100/tcp --permanent; firewall-cmd --reload

#sudo systemctl daemon-reload; sudo systemctl start node_exporter; Sudo systemctl status node_exporter; sudo systemctl enable node_exporter


}

########################################
users
install_node_exporter
set_dirs
sets_yaml_mainfile
set_exporter
set_perms
sets_yaml_mainfile
