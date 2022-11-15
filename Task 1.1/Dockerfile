FROM ubuntu:20.04
MAINTAINER Konstantin <konstantin@atomauto.ru>
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt update && apt -y full-upgrade && apt install -y software-properties-common && apt-add-repository -y ppa:rael-gc/rvm && apt install -y rvm
RUN /bin/bash -l -c ". /usr/share/rvm/scripts/rvm && rvm install ruby-2.7.2"
CMD ruby -v && tail -f /dev/null
