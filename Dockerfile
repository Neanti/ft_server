#usefull :
#creer cont docker create --tty --interactive --name="serv" ft_server
#lancer docker start --attach --interactive serv
# == donne save
#serv = test
#build cont docker build . -tftserver


FROM debian:buster
MAINTAINER augay <augay>
USER root
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y nginx
RUN apt-get install -y default-mysql-server
RUN apt-get install -y php
RUN apt-get install -y php7.3-fpm php7.3-gd php7.3-mysql php7.3-curl php7.3-imap php7.3-mbstring php7.3-xml
RUN apt-get install -y wget
COPY phpMyAdmin-5.0.1-english.tar.gz /
RUN mkdir /var/www/html/phpmyadmin
RUN tar xzf phpMyAdmin-5.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
RUN apt-get install -y emacs
#DEAL FICHIER CONFIG
#start nginx mysql php7.3-fpms dans script
RUN rm -rf /phpMyAdmin-5.0.0-english.tar.gz
RUN rm -rf /etc/nginx/sites-enabled/default
COPY default /etc/nginx/sites-enabled/
RUN rm -rf /etc/php/7.3/fpm/php.ini
COPY php.ini /etc/php/7.3/fpm/
COPY latest.tar.gz /
RUN tar -xvzf latest.tar.gz
RUN mv wordpress /var/www/html/
RUN rm -rf /var/www/html/wordpress/wp-config-sample.php
COPY wp-config-sample.php /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/wordpress
RUN chmod 755 -R /var/www/html/wordpress
#RUN rm -rf /var/lib/mysql/mysql
#COPY mysql /var/lib/mysql/
COPY wp /var/lib/mysql
COPY config.inc.php /var/www/html/phpmyadmin/
RUN service mysql start && mysql -u root -e "CREATE USER 'user'@'localhost' IDENTIFIED BY 'password'" && mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'localhost' IDENTIFIED BY 'password'" && mysql -u root -e "FLUSH PRIVILEGES"
COPY nginx-selfsigned.key /etc/ssl/private/
COPY nginx-selfsigned.crt /etc/ssl/certs/
COPY self-signed.conf /etc/nginx/snippets/
COPY ssl-params.conf /etc/nginx/snippets/
COPY dhparam.pem /etc/ssl/certs/