FROM ubuntu:trusty
MAINTAINER Juan Berner <89berner@gmail.com>

#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
ADD policy-rc.d /usr/sbin/policy-rc.d
RUN apt-get install --yes nginx
RUN apt-get install --yes curl
RUN apt-get install --yes ruby 
RUN apt-get install --yes mysql-server
RUN apt-get install --yes ruby-mysql
RUN apt-get install --yes build-essential
RUN sudo apt-get install --yes ruby1.9.1-dev

RUN gem install sinatra
RUN gem install unicorn

RUN mkdir /opt/check-config/

ADD ./check.sh /opt/check-config/
ADD ./config.ru /opt/check-config/
ADD ./api.rb /opt/check-config/
ADD ./database.sql /opt/check-config/
ADD ./nginx.conf /etc/nginx/
ADD ./unicorn.rb /opt/check-config/

RUN service mysql start &&  mysql -u root < /opt/check-config/database.sql

#CMD service nginx start && tail -F /var/log/mysql/error.log

