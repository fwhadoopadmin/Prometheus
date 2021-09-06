###################################
#!/bin/bash

# Install prometheus package ---> 
# Author : meme
##############################################

set -eu 
function  users() {

username=$(cat /etc/passwd |grep -i premetheus| awk '{print $1}'|cut -d ":" -f1| wc -l)

if [ $username == 0 ]; then
        useradd --no-create-home premetheus;

fi
}

function  set_dirs() {

dirname="/etc/prometheus"
dirname2="/var/lib/prometheus"


if [ ! -d $dirname ] 2>/dev/null; then
    mkdir -p $dirname
fi

if [ ! -d $dirname2 ] 2>/dev/null; then
    mkdir -p $dirname2
 fi

}

function install_prometheus() {

	echo "Downloading prometheus --> and files need to ne in /usr/local/bin dir  -->"

	promfile="wget https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-amd64.tar.gz"
	promzipfile="prometheus*.tar.gz"

	echo " Installing prementheus file ---> "
	eval ${promfile};
	sleep 2
	tar -xvf ${promzipfile} 2>&1 >/dev/null && \

	yes| cp -r  prometheus-2.29.2.linux-amd64/prometheus /usr/local/bin/
	yes| cp -r prometheus-2.29.2.linux-amd64/consoles/ /usr/local/bin/
	yes| cp -r  prometheus-2.29.2.linux-amd64/promtool /usr/local/bin/
	yes| cp -r  prometheus-2.29.2.linux-amd64/console_libraries /usr/local/bin/

	# /etc
	yes| cp -r prometheus-2.29.2.linux-amd64/consoles/ /etc/prometheus/
	yes| cp -r prometheus-2.29.2.linux-amd64/prometheus /var/lib/prometheus
	yes| cp -r  prometheus-2.29.2.linux-amd64/console_libraries/ /etc/prometheus/console_libraries/

	echo "Changing Permissions ---> "
	sudo chown -R prometheus:prometheus /etc/prometheus*
	sudo chown prometheus:prometheus /var/lib/prometheus*
  firewall-cmd --zone=public --add-port=9100/tcp --permanent
  firewall-cmd --zone=public --add-port=9090/tcp --permanent
  firewall-cmd --reload
  
	echo "Cleanup -time--> "
	rm -rf  prometheus-2.29.2.linux-amd64.tar.gz
	echo "Download and Install End!!!!"

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


function sets_servicefile() {
	filename=${dir}/${file}
	if [ -f $filename ]; then
	  (cat <<- _EOF_
	        [Unit]
			Description=Prometheus
			Wants=network-online.target
			After=network-online.target

			[Service]
			User=prometheus
			Group=prometheus
			Type=simple
			ExecStart=/usr/local/bin/prometheus \
			    --config.file /etc/prometheus/prometheus.yml \
			    --storage.tsdb.path /var/lib/prometheus/ \
			    --web.console.templates=/etc/prometheus/consoles \
			    --web.console.libraries=/etc/prometheus/console_libraries

			[Install]
			WantedBy=multi-user.target
	        _EOF_
	        ) > $filename
	         #>$filename &&
	        ls -ltr $filename;
	        cat $filename
	fi
}

#####################################
users
set_dirs
install_prometheus
sets_yaml_mainfile
sets_servicefile
