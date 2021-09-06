#!/bin/bash
#set up systemd service for node_exporter 
# Author: meme 
#######################################################

set -e

#set -x
function createfile() {

echo "Installing systemd node_exporter.service -->"

dir="/etc/systemd/system"

file="node_exporter.service"
filename=${dir}/${file}

if [ ! -f $filename ]; then
        echo " $file missing ---installing it --> "
        touch $filename &&  ls -ltr $filename
fi
}

function sets_servicefile() {
filename=${dir}/${file}
if [ -f $filename ]; then
  (cat <<- _EOF_
        [Unit]
        Description=Node Exporter
        [Service]
        User=node_exporter
        ExecStart=/usr/sbin/node_exporter
                #--config.file /etc/prometheus/prometheus.yml \
                #--collector.mountstats \
                #--collector.logind \
                #--collector.processes \
                #--collector.ntp \
                #--collector.systemd \
                #--collector.tcpstat \
        [Install]
        WantedBy=multi-user.target
        _EOF_
        ) > $filename

         #>$filename &&
        ls -ltr $filename;
        cat $filename
fi
}
########################################
#call functions 
createfile
sets_servicefile
