FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install wget nano gnupg -y && \
    apt-get install tzdata -y && \
    ln -fs /usr/share/zoneinfo/US/Central /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get install locales -y && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    echo deb http://debian.koha-community.org/koha stable main | tee /etc/apt/sources.list.d/koha.list && \
    wget -O- https://debian.koha-community.org/koha/gpg.asc | gpg --dearmour -o /etc/apt/trusted.gpg.d/koha.gpg && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install koha-common -y && \
	apt-get install mysql-server -y && \
	a2enmod rewrite && \
	a2enmod cgi && \
    a2dissite 000-default.conf    

COPY ./koha-sites.conf /etc/koha/koha-sites.conf
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod +rx /usr/local/bin/docker-entrypoint.sh
    
EXPOSE 80 443 3306

ENTRYPOINT ["docker-entrypoint.sh"]