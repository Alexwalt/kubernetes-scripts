#!/bin/bash

kubeadm reset
#rpm -qa|grep kube*|xargs rpm --nodeps -e
#docker images -qa|xargs docker rmi -f

# delete .kube dicrtory
rm -rf $HOME/.kube
