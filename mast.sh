#!/bin/bash

 
 images=(
 kube-apiserver:v$KUBERNETES_VERSION
 kube-proxy:v$KUBERNETES_VERSION
 kube-controller-manager:v$KUBERNETES_VERSION
 kube-scheduler:v$KUBERNETES_VERSION
 coredns:1.6.5
 etcd:3.4.3-0
 pause:3.1
 )
 for imageName in ${images[@]}; do
   docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
 done