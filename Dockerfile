FROM ubuntu:trusty
MAINTAINER Juan Berner <89berner@gmail.com>
RUN apt-get update
RUN apt-get install --yes nginx
RUN mkdir /opt/check-config
ADD check.sh /opt/check-config
ADD config.ru /opt/check-config
ADD api.rb /opt/check-config
ADD nginx.conf /etc/nginx/
