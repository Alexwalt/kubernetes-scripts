# 说明
## 安装kubernetes基础脚本
适用于`CentOS 7.9`，`kubernetes`版本为1.17.3，`docker`版本为19.03.8
版本号可在`install-kubernetes.sh`头部替换

## 安装环境
```bash
chmod +x tools/*
./tools/install-kubernetes.sh
```

## 初始化集群
```bash
kubeadm init \
 --apiserver-advertise-address=172.26.248.150 \
 --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers \
 --kubernetes-version=v1.17.3 \
# --service-cidr=10.96.0.0/16 \
# --pod-network-cidr=10.244.0.0/16
```

## 从节点加入集群

```
kubeadm join 172.26.248.150:6443 --tokenktnvuj.tgldo613ejg5a3x4 \
    --discovery-token-ca-cert-hashsha256:f66c496cf7eb8aa06e1a7cdb9b6be5b013c613cdcf5d1bbd88a6ea19a2b454ec
    
#2、如果超过2小时忘记了令牌，可以这样做
kubeadm token create --print-join-command #打印新令牌
kubeadm token create --ttl0--print-join-command#创建个永不过期的令牌
```



## 安装网络组件`calico`

```
./toots/network-calico.sh
```

