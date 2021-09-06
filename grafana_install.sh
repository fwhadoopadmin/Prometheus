#!/bin/bash
set -eu

filename="wget https://dl.grafana.com/enterprise/release/grafana-enterprise-8.1.2-1.x86_64.rpm"

grafanazip="grafana-enterprise-8.1.2-1.x86_64.rpm"

eval $filename && \

sudo yum install ${grafanazip} && \
#grafana-enterprise-8.1.2-1.x86_64.rpm && \

systemctl enable grafana-server; systemctl start grafana-server; systemctl status grafana-server

echo " Grafana Install Completed!!"

