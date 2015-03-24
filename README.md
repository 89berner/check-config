# conf-check
Simple and centralized configuration control for linux servers.<br/>

Description: API to centralize configuration of different files. Using nginx and unicorn for scalability.<br/>

Install instructions for stand alone api:<br/>

git clone https://github.com/89berner/check-config.git <br/>
apt-get install --yes ruby-mysql<br/>
apt-get install --yes mysql-server<br/>
wget http://www.uni.edu/~prefect/devel/chkconfig/chkconfig-v.5.tar.gz -O /tmp/chkconfig-v.5.tar.gz && cd /tmp/ && tar zxvf /tmp/chkconfig-v.5.tar.gz && cp /tmp/chkconfig-v.5/chkconfig /usr/local/bin/chkconfig && chmod 755 /usr/local/bin/chkconfig<br/>
service mysql start &&  mysql -u root < /opt/check-config/database.sql<br/>
nohup ruby api.rb debug &<br/>
bash check.sh<br/>

Install instructions for api with unicorn and nginx:<br/>

See Dockerfile<br/>

File description:<br/><br/>
api.rb: Sinatra based web api to receive files as POST request and upload information to the database.<br/>
check.sh: Example bash script to upload files to the api.<br/>
database.sql: SQL script to create the database.<br/>
nginx.conf: Configuration for the nginx load balancer.<br/>
policy-rc.d: Policy for docker build.<br/>
unicorn.rb:  Unicorn configuration file.<br/>
config.ru: Unicorn configuration file.<br/>
Dockerfile: Docker build instructions<br/>
