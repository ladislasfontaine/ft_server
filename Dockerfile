# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lafontai <lafontai@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/05/10 19:08:56 by lafontai          #+#    #+#              #
#    Updated: 2020/05/27 16:54:27 by lafontai         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# image
FROM debian:buster

#update
RUN apt-get update && apt-get upgrade -y

#install tools
RUN apt-get -y install wget

#install nginx
RUN apt-get -y install nginx

#install PHP
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli php-mbstring

#install mySQL
RUN apt-get -y install mariadb-server

#copy sources
COPY ./srcs/init.sh ./
COPY ./srcs/nginx.conf	./etc/nginx/sites-available/localhost
COPY ./srcs/config.inc.php ./
COPY ./srcs/wp-config.php ./

#launch script
RUN chmod 755 ./init.sh
CMD bash ./init.sh

#open ports
EXPOSE 80 443

#set variable
ENV AUTO_INDEX on

#docker build -t IMAGE_NAME .
#docker run -d -p 81:80 -p 443:443 IMAGE_NAME (-e AUTO_INDEX=off if you want to desactivate autoindex)
