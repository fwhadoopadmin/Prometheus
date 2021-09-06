#!/bin/bash
set -eu

filename="wget https://dl.grafana.com/enterprise/release/grafana-enterprise-8.1.2-1.x86_64.rpm"

grafanazip="grafana-enterprise-8.1.2-1.x86_64.rpm"

eval $filename && \

sudo yum install ${grafanazip} && \
#grafana-enterprise-8.1.2-1.x86_64.rpm && \

echo "Enable firewall ---> "
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent;firewall-cmd --reload 

sudo systemctl enable grafana-server; sudo systemctl start grafana-server; sudo systemctl status grafana-server

echo " Grafana Install Completed!!"

