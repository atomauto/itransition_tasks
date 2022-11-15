#!/bin/bash
logfile='task1.1.log'
function usage() {
    echo "This script performs actions according to its task (same filename with .md extension)"
    echo "You must run script with root privilegies (please, use sudo)"
    echo "If you want to install latest version of docker, specify key -f or --docker-repo"
    echo "Some script information can be found in $logfile"
}

if [[ "$1" == -h || "$1" == --help ]]; then
    usage
    exit 0
fi

#Considering running script with root privilegies
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privilegies"
    echo "Unsuccesful script run (not enough rights)" > $logfile
    exit 1
fi

#By default we install docker and docker-compose from distro repository
source='distro'
if [[ "$1" == -f || "$1" == --docker-repo ]]; then
    source='docker'
fi
echo "Script started with root privilegies, source of docker repo is $source" > $logfile
#Using deb-based distribution (checked with Kubuntu 22.04.1 LTS)
apt update >> $logfile && apt full-upgrade -y >> $logfile

if [[ $source == 'distro' ]]; then
    apt install -y docker docker-compose >> $logfile
else
    apt install -y ca-certificates curl gnupg lsb-release >> $logfile
    mkdir -p /etc/apt/keyrings
    #Auto selection Debian or Ubuntu
    if lsb_release -d | grep Debian >/dev/null; then
        curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >> $logfile
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
    elif lsb_release -d | grep Ubuntu >/dev/null; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg >> $logfile
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
    else
        echo "Script supports only Ubuntu and Debian distributions if you use official Docker repository"
        echo "Docker official repo for deb is supported only for Ubuntu and Debian. You can try use Debian or Ubuntu repo on your own risk." >> $logfile
        echo "Please look Docker documentation for your distribution" >> $logfile
        exit 2
    fi
    chmod a+r /etc/apt/keyrings/docker.gpg
    apt update >> $logfile
    apt install install docker-ce docker-ce-cli containerd.io docker-compose-plugin >> $logfile
fi

#Preparing environment for rootless docker run under usual user
#https://docs.docker.com/engine/security/rootless/
apt install -y uidmap dbus-user-session >> $logfile
if lsb_release -d | grep Debian >/dev/null; then
    apt install -y slirp4netns fuse-overlayfs >> $logfile
fi

if docker run -d -p 80:80 nginx >> $logfile; then
echo "Nginx docker container deployed with access to port 80"
else
echo "Nginx containter cannot be started, sorry"
fi

#Not necessary, but we want to check nginx without using DE and browser
apt install -y w3m >> $logfile

echo "Below is page from http://localhost:80"
w3m -dump http://localhost:80

#Warning: all distros use MariaDb instead of MySQL, maybe it's better mention MariaDb in task?
if docker run -d -p 3306:3306 --env="MYSQL_ROOT_PASSWORD=lolsometext" -v mysql:/var/lib/mysql mysql >> $logfile; then
echo "MySQL docker container deployed with access to port 3306"
else
echo "MySQL containter cannot be started, sorry"
fi

#Trying to connect from local client, connection from container is harder to automatize
apt install -y mysql-client >> $logfile

#Notice: using in connection host name as localhost will cause error, because mysql would try to connect to unix socket
mysql -u root --password=lolsometext -h 127.0.0.1 \
-e "CREATE DATABASE task; CREATE USER task IDENTIFIED BY 'task'; USE task;  GRANT ALL PRIVILEGES ON task TO task;"

#Generate Dockerfile
echo "FROM ubuntu:20.04" > Dockerfile
echo "MAINTAINER Konstantin <konstantin@atomauto.ru>" >> Dockerfile
#Wrong, because ruby version is not 2.7.2
#echo "RUN apt update && apt -y full-upgrade && apt install -y ruby-full" >> Dockerfile
#Special args for handling tzdata asking interactive input
echo "ARG DEBIAN_FRONTEND=noninteractive" >> Dockerfile
echo "ENV TZ=Europe/Moscow" >> Dockerfile
#Warning: for production we shouldn't install so many packages and rbenv
#rbenv script is stuck((
# echo "RUN apt update && apt -y full-upgrade && apt install -y curl git make gcc build-essential libz-dev libssl-dev \
# libreadline-dev zlib1g-dev autoconf bison libyaml-dev libncurses5-dev libffi-dev libgdbm-dev && \
# curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash &&\ 
# ~/.rbenv/bin/rbenv install 2.7.2 && ~/.rbenv/bin/rbenv global 2.7.2 &&\ 
# ln -s '/root/.rbenv/versions/2.7.2/bin/ruby' /usr/sbin/ruby &&  rm -rf /var/lib/apt/lists/*" >> Dockerfile
#Below is also installed wrong version, it's 2.7.5 :(
# echo "RUN apt update && apt -y full-upgrade && apt install -y software-properties-common && \
# apt-add-repository ppa:brightbox/ruby-ng && apt install -y ruby2.7" >> Dockerfile
#RVM is bad for non-interactive docker install
echo "RUN apt update && apt -y full-upgrade && apt install -y software-properties-common && \
apt-add-repository -y ppa:rael-gc/rvm && apt install -y rvm" >> Dockerfile
echo "RUN /bin/bash -l -c \". /usr/share/rvm/scripts/rvm && rvm install ruby-2.7.2\"" >> Dockerfile
#Tail is used to force container running
echo "CMD ruby -v && tail -f /dev/null" >> Dockerfile
docker build . -t ruby >> $logfile
echo "Ruby docker is builded, below is container id and output from container"
docker run -d ruby
docker container exec -it ruby ruby -v

#Stopping previous container to free ports
docker stop $(docker ps -a -q)
echo "\
services:
  database:
    image: mariadb
    command: '--default-authentication-plugin=mysql_native_password'
    volumes:
      - database:/var/lib/mysql
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=sillypassword
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - MYSQL_PASSWORD=wordpress
    expose:
      - 3306
  wordpress:
    image: wordpress:latest
    volumes:
      - wordpress:/var/www/html
    ports:
      - 80:80
    restart: always
    environment:
      - WORDPRESS_DB_HOST=database
      - WORDPRESS_DB_USER=wordpress
      - WORDPRESS_DB_PASSWORD=wordpress
      - WORDPRESS_DB_NAME=wordpress
volumes:
  database:
  wordpress:
" > docker-compose.yml
docker compose up -d
echo "Below is page from http://localhost:80"
w3m -dump http://localhost:80

echo "This is the end..."
echo "Thank you for your time"