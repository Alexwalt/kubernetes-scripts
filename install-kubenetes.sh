#!/bin/bash
KUBERNETES_VERSION=1.20.13
DOCKER_VERSION=19.03.8

export KUBERNETES_VERSION
export DOCKER_VERSION
# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭selinux
sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0

# 关闭swap分区
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab

# 修改 /etc/sysctl.conf
core_config=(
net.ipv4.ip_forward
net.bridge.bridge-nf-call-ip6tables
net.bridge.bridge-nf-call-iptables
net.ipv6.conf.all.disable_ipv6
net.ipv6.conf.default.disable_ipv6
net.ipv6.conf.all.forwarding
)
for item in ${core_config[@]};
do
   sed -i "/${item}/d" /etc/sysctl.conf
   echo "${item} = 1" >> /etc/sysctl.conf
done

sysctl -p

yum remove docker \
 docker-client \
 docker-client-latest \
 docker-common \
 docker-latest \
 docker-latest-logrotate \
 docker-logrotate \
 docker-engine

yum install -y yum-utils \
 device-mapper-persistent-data \
 lvm2 nfs-utils

yum-config-manager \
 --add-repo\
 http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

yum install -y docker-ce-$DOCKER_VERSION docker-ce-cli-$DOCKER_VERSION containerd.io
systemctl enable docker
systemctl start docker

 # 配置docker加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json << 'EOF'
{
"registry-mirrors": ["https://82m9ar63.mirror.aliyuncs.com"]
}
EOF

# 安装k8s、kubelet、kubeadm、kubectl
yum remove -y kubelet kubeadm kubectl

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum install -y kubelet-$KUBERNETES_VERSION kubeadm-$KUBERNETES_VERSION kubectl-$KUBERNETES_VERSION
systemctl enable kubelet && systemctl start kubelet

chmod 777 ./mast.sh
./mast.sh 