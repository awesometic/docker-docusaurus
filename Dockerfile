FROM node:current-alpine3.14
LABEL maintainer="Deokgyu Yang <secugyu@gmail.com>" \
      description="Lightweight Docusaurus container with Node.js based on Alpine Linux"

RUN apk add --no-cache \
    bash bash-completion supervisor \
    autoconf automake build-base libtool nasm

# Environments
ENV TARGET_UID=1000
ENV TARGET_GID=1000
ENV AUTO_UPDATE='true'
ENV WEBSITE_NAME='MyWebsite'
ENV TEMPLATE='classic'
ENV RUN_MODE='development'

# Create Docusaurus directory and change working directory to that
RUN mkdir /docusaurus
WORKDIR /docusaurus

# Copy configuration files
ADD config/init.sh /
ADD config/auto_update_crontab.txt /
ADD config/auto_update_job.sh /
ADD config/run.sh /
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set files permission
RUN chmod a+x /init.sh /auto_update_job.sh /run.sh

EXPOSE 80
VOLUME [ "/docusaurus" ]
ENTRYPOINT [ "/init.sh" ]

