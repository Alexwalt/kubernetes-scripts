#!/bin/bash
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# 等待默认存储安装完成
status=FAILED
printf "waiting "
while [[ $status != "Running" ]]
do
    sleep 2s
    status=$(kubectl get po -A | grep calico-kube | awk '{print $4}')
    printf "."
done
printf "\n"
echo "calico install done!"