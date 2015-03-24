# conf-check
Simple and centralized configuration control for linux servers.

Description: API to centralize configuration of different files. Using nginx and unicorn for scalability.

Install instructions for stand alone api:

git clone https://github.com/89berner/check-config.git 
apt-get install --yes ruby-mysql
apt-get install --yes mysql-server
wget http://www.uni.edu/~prefect/devel/chkconfig/chkconfig-v.5.tar.gz -O /tmp/chkconfig-v.5.tar.gz && cd /tmp/ && tar zxvf /tmp/chkconfig-v.5.tar.gz && cp /tmp/chkconfig-v.5/chkconfig /usr/local/bin/chkconfig && chmod 755 /usr/local/bin/chkconfig
service mysql start &&  mysql -u root < /opt/check-config/database.sql
nohup ruby api.rb debug &
bash check.sh

Install instructions for api with unicorn and nginx:

See Dockerfile

File description:
api.rb: Sinatra based web api to receive files as POST request and upload information to the database.
check.sh: Example bash script to upload files to the api.
database.sql: SQL script to create the database.
nginx.conf: Configuration for the nginx load balancer.
policy-rc.d: Policy for docker build.
unicorn.rb:  Unicorn configuration file.
config.ru: Unicorn configuration file.
Dockerfile: Docker build instructions
