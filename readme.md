# vagrant-k8z

this ran with/on, also provisions:

```
vagrant --version = Vagrant 2.0.4 

vagrant plugin list:
  vagrant-hostmanager (1.8.5)
  vagrant-hostsupdater (1.0.2)
  vagrant-share (1.1.6, system)

etcd --version:
  etcd Version: 3.3.8
  Git SHA: d267ca9
  Go Version: go1.7.5
  Go OS/Arch: linux/amd64

etcdctl --version:
  etcdctl version: 3.3.8̨
  API version: 2

docker --version =   Docker version 18.03.1-ce

kubernetes v1.10.4

/usr/local/flanneld --version =  v0.10.0
```

## to start

``` vagrant up ```

you can control k8z master from master node or from host machine that vagrant is running on.



to run kube-dns

```kubectl create -f kube-dns.yaml```
