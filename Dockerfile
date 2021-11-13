FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install sudo -y
RUN apt-get update && apt-get install vim -y
RUN apt-get install apache2-utils -y
RUN apt-get install net-tools -y
RUN apt-get install iputils-ping -y
RUN apt-get install curl -y
RUN apt-get install apache2 -y

RUN sudo adduser user1
RUN sudo passwd -d user1
RUN sudo usermod -aG sudo user1

RUN a2enmod userdir
RUN a2enmod autoindex

WORKDIR /home/user1/public_html
COPY index.html .
RUN sudo mkdir Dev

WORKDIR /home/user1/public_html/Dev
COPY simple.html index.html
COPY .htaccess .

RUN sudo htpasswd -bc /etc/apache2/.htpasswd user1 passw0rd

COPY site1.conf /etc/apache2/sites-available
COPY site2.conf /etc/apache2/sites-available
COPY site3.conf /etc/apache2/sites-available

RUN sudo mkdir -p /var/www//html/site1/public_html
COPY site1index.html /var/www/html/site1/public_html/index.html
RUN a2ensite site1.conf

RUN sudo mkdir -p /var/www/html/site2/public_html
COPY site2index.html /var/www/html/site2/public_html/index.html
RUN a2ensite site2.conf

RUN sudo mkdir -p /var/www/html/site3/public_html
COPY site3index.html /var/www/html/site3/public_html/index.html
RUN a2ensite site3.conf

RUN sudo chmod -R 755 /var/www

Label Maintainer: "edgar.aguilar.189@my.csun.edu"
Expose 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
