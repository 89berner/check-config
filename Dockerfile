FROM ubuntu:trusty
MAINTAINER Juan Berner <89berner@gmail.com>

#RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
ADD policy-rc.d /usr/sbin/policy-rc.d
RUN apt-get install --yes nginx
RUN apt-get install --yes curl
RUN apt-get install --yes ruby 
RUN gem install sinatra
RUN mkdir -p /opt/check-config/sockets

ADD ./check.sh /opt/check-config/
ADD ./config.ru /opt/check-config/
ADD ./api.rb /opt/check-config/
ADD ./nginx.conf /etc/nginx/
