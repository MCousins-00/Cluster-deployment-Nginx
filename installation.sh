#! /bin/bash
#################run on three devices Master,node1 node2###############
sudo swapoff -a
cat /proc/meminfo | grep 'SwapTotal'
sudo apt remove docker docker-engine docker.io
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce

########optional#############
sudo useradd marc 
sudo useradd -aG docker marc 


#Setup the Docker daemon to use systemd as the cgroup driver, instead of the default cgroupfs.#
# This is a recommended step so that kubelet and Docker are both using the same cgroup manager. This makes it easier for Kubernetes to know which resources are available on your cluster’s nodes.#

sudo bash -c 'cat > /etc/docker/daemon.json <<EOF
 {
   "exec-opts": ["native.cgroupdriver=systemd"],
   "log-driver": "json-file",
   "log-opts": {
     "max-size": "100m"
   },
   "storage-driver": "overlay2"
 }
 EOF'


##### Create a systemd directory for Docker##########
sudo mkdir -p /etc/systemd/system/docker.service.d


###########Restart docker##############
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker



####install Repository### kubeadm, kubelet, and kubectl############
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
 sudo apt-get install -y kubelet kubeadm kubectl
 sudo apt-mark hold kubelet kubeadm kubectl
 command kubeadm version
 command kubelet --version
 command kubectl version
