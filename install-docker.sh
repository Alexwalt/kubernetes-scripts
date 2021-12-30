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

yum install epel-release -y && yum install htop vim -y

yum remove docker \
 docker-client \
 docker-client-latest \
 docker-common \
 docker-latest \
 docker-latest-logrotate \
 docker-logrotate \
 docker-engine

yum install -y yum-utils \
 device-mapper--data \
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
