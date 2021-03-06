FROM ubuntu:16.04

# install dependencies from packages
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -q -y \
        build-essential \
        wget \
        git \
        vim \
        libpq-dev \
	mysql-server \
        libmysqlclient-dev \
        python-dev \
	python-setuptools \
        python-pip \
        dialog \
        net-tools \
	nginx

# clone the django site
RUN git clone https://github.com/biobakery/jdrf2.git /usr/local/src/

# install python dependencies
RUN pip install --upgrade pip && \
    pip install setuptools && \
    pip install supervisor && \
    pip install django==1.11.0 gunicorn==19.7 MySQL-python==1.2.5 && \
    pip install django-filer==1.2.8

# add supervisor conf
RUN mkdir -pv /var/log/supervisord
ADD etc/supervisor.ini /etc/supervisord.conf

# replace nginx config to proxy gunicorn
RUN rm -v /etc/nginx/nginx.conf
ADD etc/jdrf_nginx.conf /etc/nginx/nginx.conf

EXPOSE :80

