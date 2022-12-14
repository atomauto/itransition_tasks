#!/bin/bash
#shellcheck disable=SC2024
logfile='task1.2.log'
function usage() {
    echo "Usage: $(basename $0) [-h] [-d] [-r]"
    echo " -d, --driver <driver>           Virtualization driver for kubectl, only kvm and docker are supported, default is kvm"
    echo " -r, --kubectl_release <release> Release version of kubectl, default is latest stable"
    echo " -h, --help                      Show this help"
    echo ""
    echo "This script performs actions according to its task (same filename with .md extension)"
    echo "Debug information can be found in $logfile"
}

# if [[ "$1" == -h || "$1" == --help ]]; then
#     usage
#     exit 0
# fi

#Default opts
driver="kvm"
kubectl_release=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

while :; do
    case "$1" in
    -d | --driver)
        shift
        driver="$1"
        shift
        ;;
    -r | --kubect_release)
        shift
        kubectl_release="$1"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
        #   --) # End of all options
        #   shift
        #   break;
        #   -*)
        #   echo "Error: Unknown option: $1" >&2
        #   exit 1
        #   ;;
    *) # No more options
        break
        ;;
    esac
done

if [[ $(grep -E -c 'vmx|svm' /proc/cpuinfo) -eq 0 ]]; then
    echo "Virtualiazition isn't supported by your CPU"
    echo "Maybe, you should try to install minikube manual with 'docker' or 'none' driver"
    echo "https://kubernetes.io/ru/docs/tasks/tools/install-minikube/"
    echo "https://minikube.sigs.k8s.io/docs/drivers/docker/"
    echo "Now script is switched to docker driver"
    driver="docker"
    echo "Script succesfully started, virtualization isn't supported, switched to docker driver" >$logfile
else
echo "Script succesfully started, virtualization is supported" >$logfile
fi
echo "Downloading kubectl, please wait..."
curl -LO https://storage.googleapis.com/kubernetes-release/release/$kubectl_release/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#Enable autocompletion for kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null

#Finding distribution name
if lsb_release -d | grep Debian >/dev/null; then
    distro="Debian"
elif lsb_release -d | grep Ubuntu >/dev/null; then
    distro="Ubuntu"
fi
#KVM driver installation
if [[ $driver == "kvm" ]]; then
    echo "Installing kvm support..."
    if [[ $distro == "Debian" ]]; then
        sudo apt install -y --no-install-recommends qemu-system libvirt-daemon-system libvirt-clients >>$logfile 2>&1
    elif [[ $distro == "Ubuntu" ]]; then
        sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils >>$logfile 2>&1
        sudo setfacl -m user:$USER:rw /var/run/libvirt/libvirt-sock
        sudo systemctl enable libvirtd
        sudo systemctl start libvirtd
    else
        echo "Script supports KVM installation only for Debian and Ubuntu"
        echo "Please install on your own KVM support according to your distro doc"
        echo "Now script will be switched to 'docker' driver"
        driver='docker'
    fi
fi

echo "Downloading minikube, please wait..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
if [[ $driver == "kvm" ]]; then
    minikube start --vm-driver=kvm2
else
    minikube start --vm-driver=docker
fi

# echo "Downloading AWK server code, please wait..."
# git clone https://github.com/kevin-albert/awkserver.git
# rm -rf awkserver/.git/ && rm awkserver/.gitignore

#Fix to use local docker image
eval $(minikube -p minikube docker-env)
echo "Building docker image, please wait..."
sudo docker build -t awk-server .
kubectl create -f awk-service-namespace.yml
kubectl config set-context kubectl config current-context --namespace=sandbox
kubectl apply -f awk-deployment.yaml
# kubectl apply -f awk-service.yaml
#Using 8080 port on local machine to avoid security issues accessing 80 without root rights
kubectl port-forward deployments/awk-deployment 8080:80

echo "Results: "
kubectl get pods -A
kubectl get svc
kubectl get all

#Need graceful shutdown
minikube stop