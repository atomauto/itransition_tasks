#!/bin/bash
#shellcheck disable=SC2164

logfile=$(basename -s .sh "$0").log
function usage() {
    echo "Usage: $(basename $0) [-h]"
    echo " -h, --help                  Show this help"
    echo ""
    echo "This script installs LEMP according to task"
    echo "You should launch script from prepare_linux before this according to your distribution"
    echo "Debug information can be found in $logfile"
}

while :; do
    case "$1" in
    -h | --help)
        usage
        exit 0
        ;;
    *) # No more options
        break
        ;;
    esac
done

vagrant up
vagrant ssh -c "echo \"Running script now inside vagrant\" && sudo apt update && sudo apt install git -y && git clone https://github.com/atomauto/prepare_linux"
vagrant ssh -c "cd prepare_linux && chmod +x debian.sh && sudo ./debian.sh"
vagrant ssh -c "sudo apt install -y nginx-light mariadb-server mariadb-client php-fpm php-pear php-cgi php-common php-mbstring php-zip php-net-socket php-gd php-xml-util php-mysql php-bcmath unzip"
# echo -ne "\n" or yes "" doesn't work for mysql password prompt, so user has to press Enter manually (
vagrant ssh -c "yes \"\" | sudo mysql -u root -p -e \"CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* to wordpress@localhost identified by 'wordpress';\""
vagrant ssh -c "sudo mv ~/wordpress /etc/nginx/sites-available/wordpress"
vagrant ssh -c "sudo rm /etc/nginx/sites-enabled/default && sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress && sudo service nginx restart"
vagrant ssh -c "cd /var/www && sudo mkdir wordpress && cd wordpress && sudo wget https://wordpress.org/latest.tar.gz && sudo tar -zxvf latest.tar.gz && sudo mv wordpress/* . && sudo rm -rf wordpress"
vagrant ssh -c "sudo chown -R www-data:www-data * && sudo chmod -R 755 *"
vagrant ssh -c "sudo mv ~/wp-config.php /var/www/wordpress/wp-config.php"
vagrant ssh -c "sudo apt install -y logrotate"
vagrant ssh -c "grep \"find\" /etc/crontab || echo \"00 00 * * * root find /tmp -type f -mtime +14 -size +5M -delete\" | sudo tee -a /etc/crontab"
vagrant ssh -c "sudo mv ~/nginx.conf /etc/nginx/nginx.conf"
vagrant ssh -c "echo \"php_admin_flag[expose_php] = off\"|sudo tee -a /etc/php/7.4/fpm/php-fpm.conf"
vagrant ssh -c "sudo service php7.4-fpm restart && sudo service nginx restart"