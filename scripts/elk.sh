#!/bin/bash

apt update -y
apt upgrade -y
apt install default-jre -y
# Install Elasticsearch Debian Package 
# ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
apt-get install apt-transport-https
apt update
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
apt-get update && apt-get install elasticsearch
apt-get install kibana
apt-get install logstash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.13.2-amd64.deb
dpkg -i filebeat-8.13.2-amd64.deb
rm filebeat*
filebeat modules enable system
filebeat modules enable cisco
filebeat modules enable netflow
filebeat modules enable osquery
filebeat modules enable elasticsearch
filebeat modules enable kibana
filebeat modules enable logstash
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.13.2-amd64.deb
dpkg -i metricbeat-8.13.2-amd64.deb
rm metricbeat*
metricbeat modules enable elasticsearch
metricbeat modules enable kibana
metricbeat modules enable logstash
metricbeat modules enable system
apt-get install libpcap0.8
curl -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-8.13.2-amd64.deb
dpkg -i packetbeat-8.13.2-amd64.deb
rm packetbeat*
curl -L -O https://artifacts.elastic.co/downloads/beats/auditbeat/auditbeat-8.13.2-amd64.deb
dpkg -i auditbeat-8.13.2-amd64.deb
rm auditbeat*
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl start elasticsearch.service
echo "$(tput setaf 1) ---- Starting Kibana ----"
/bin/systemctl enable kibana.service
/bin/systemctl start kibana.service
echo "$(tput setaf 1) ---- Starting Logstash ----"
/bin/systemctl enable logstash.service
/bin/systemctl start logstash.service
systemctl enable filebeat
systemctl start filebeat
filebeat setup -e
filebeat setup --dashboards
filebeat setup --index-management
filebeat setup --pipelines
systemctl enable metricbeat
systemctl start metricbeat
metricbeat setup -e
metricbeat setup --dashboards
metricbeat setup --index-management
metricbeat setup --pipelines
systemctl enable packetbeat
systemctl start packetbeat
packetbeat setup -e
packetbeat setup --dashboards
packetbeat setup --index-management
packetbeat setup --pipelines
systemctl enable auditbeat
systemctl start auditbeat
auditbeat setup -e
auditbeat setup --dashboards
auditbeat setup --index-management
auditbeat setup --pipelines
echo "$(tput setaf 1) ---- Now It's Your Turn: Finsh Configuration ----"
echo "$(tput setaf 3) 1. edit kibana.yml and change server.host to 0.0.0.0 so that you can connect to kibana from other systems http://IPADDRESS:5601"
echo "$(tput setaf 3) 2. edit elasticsearch.yml and change network.host to 0.0.0.0 so that other systems can send data to elasticsearch"
echo "$(tput setaf 3) 3. restart both services systemctl restart elasticsearch kibana"

