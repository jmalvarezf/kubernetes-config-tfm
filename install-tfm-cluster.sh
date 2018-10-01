##################################################################
## 1. INSTALL VIRTUALBOX
## https://www.virtualbox.org/wiki/Linux_Downloads
##################################################################

echo "deb https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee -a /etc/apt/sources.list.d/virtualbox.list

wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo apt update
sudo apt install -y virtualbox-5.2

##################################################################
## 2. INSTALL KUBECTL
## https://kubernetes.io/docs/tasks/tools/install-kubectl/
##################################################################

sudo apt update && sudo apt install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


##################################################################
## 3. INSTALL & START MINIKUBE
## https://github.com/kubernetes/minikube/releases
##################################################################

curl -Lo /tmp/minikube https://storage.googleapis.com/minikube/releases/v0.29.0/minikube-linux-amd64 && chmod +x /tmp/minikube && sudo cp /tmp/minikube /usr/local/bin/ && rm /tmp/minikube && minikube version

minikube start --memory 8192
minikube dashboard

##################################################################
## 4. GET TFM DEPLOYMENT FILES
## https://github.com/jmalvarezf/kubernetes-config-tfm/tree/master
##################################################################
sudo apt install git
mkdir ~/tfm
cd ~/tfm
git clone https://github.com/jmalvarezf/kubernetes-config-tfm.git
cd kubernetes-config-tfm/

echo "Installing Zookeeper & Kafka..."
kubectl create -f zookeeper.yml
kubectl create -f kafka.yml
kubectl create -f kafka-connect.yml
kubectl get  pods,services -o wide

echo "Installing Customer Service..."
kubectl create -f customer-service.yml
kubectl get  pods,services -o wide

echo "Installing Kafka Rest Proxy..."
kubectl create -f rest-proxy.yml
kubectl get  pods,services -o wide

echo "Installing Event Stream Processor..."
kubectl create -f event-stream-processor.yml
kubectl get  pods,services -o wide

echo "Installing Event Sender..."
kubectl create -f event-sender.yml
kubectl get  pods,services -o wide

##################################################################
## 5. INSTALL HELM
## https://github.com/helm/helm/releases
##################################################################

mkdir -p /tmp/helm && curl -Lo /tmp/helm-v2.11.0-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz && tar xzf /tmp/helm-v2.11.0-linux-amd64.tar.gz -C /tmp/helm && sudo cp /tmp/helm/linux-amd64/helm /usr/local/bin && rm -fr /tmp/helm
helm init

##################################################################
## 6. INSTALL ELASTIC USING HELM
## https://github.com/jmalvarezf/helm-elasticsearch
##################################################################
cd ~/tfm
git clone https://github.com/jmalvarezf/helm-elasticsearch.git elasticsearch
helm install ~/tfm/elasticsearch


