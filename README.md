# conf-check
Simple and centralized configuration control for linux servers.<br/>

Description: API to centralize configuration of different files. Using nginx and unicorn for scalability.<br/>

Install instructions for docker container:<br/><br/>
docker pull 89berner/check_config <br/>
docker run -i -t 89berner/check_config:v1 /bin/bash<br/>
service mysql start<br/>
nohup ruby /opt/check-config/api.rb debug & <br/>
<br/>
root@9031854177fe:/# bash /opt/check-config/check.sh<br/>
File dpkg.tmp was uploaded<br/>
6 elements were uploaded for sudoers<br/>
25 elements were uploaded for chkconfig.tmp<br/><br/>
<br/><br/>

File description:<br/><br/>
api.rb: Sinatra based web api to receive files as POST request and upload information to the database.<br/>
check.sh: Example bash script to upload files to the api.<br/>
database.sql: SQL script to create the database.<br/>
nginx.conf: Configuration for the nginx load balancer.<br/>
policy-rc.d: Policy for docker build.<br/>
unicorn.rb:  Unicorn configuration file.<br/>
config.ru: Unicorn configuration file.<br/>
Dockerfile: Docker build instructions<br/>
