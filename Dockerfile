FROM ubuntu
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update -y

RUN apt-get install apache2-utils -y
RUN apt-get install apache2 -y 
RUN echo "this is created using using dockerfile" > /var/www/html/index.html


RUN service apache2 restart
EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]

