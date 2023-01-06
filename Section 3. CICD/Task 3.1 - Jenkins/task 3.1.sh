#!/bin/bash
#shellcheck disable=SC2086

logfile=$(basename -s .sh "$0").log
function usage() {
    echo "Usage: $(basename $0) [-h]"
    echo " -h, --help                  Show this help"
    echo ""
    echo "This script do tasks accroding to readme"
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
vagrant ssh -c "echo \"deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main\" > ansible.list && sudo mv ansible.list /etc/apt/sources.list.d/ansible.list" controlnode
vagrant ssh -c "sudo apt install -y gnupg && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && sudo apt update && sudo apt install ansible -y" controlnode
vagrant ssh -c "sudo cp /vagrant/etc/ansible/hosts /etc/ansible/hosts" controlnode
vagrant ssh -c "ssh-keygen -f ~/.ssh/id_rsa -N '' && sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && sudo chmod og-wx ~/.ssh/authorized_keys" controlnode
vagrant ssh -c "cd ansible && ansible-playbook playbook.yml" controlnode
vagrant ssh -c "sudo cat /var/lib/jenkins/secrets/initialAdminPassword" controlnode