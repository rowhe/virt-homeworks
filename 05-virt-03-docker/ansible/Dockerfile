FROM ubuntu:latest
MAINTAINER Denis Popov <dpopov.pro@yandex.ru>
RUN apt-get update && \
    apt-get install -y apt-utils &&\
    apt-get install -y gpg-agent && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts
RUN ["/bin/bash"]
