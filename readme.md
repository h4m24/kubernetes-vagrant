# vagrant-k8z

this ran with/on, also provisions:

```
vagrant --version = Vagrant 1.9.1

vagrant plugin list:
  vagrant-hostmanager (1.8.5)
  vagrant-hostsupdater (1.0.2)
  vagrant-share (1.1.6, system)

etcd --version:
  etcd Version: 3.1.8
  Git SHA: d267ca9
  Go Version: go1.7.5
  Go OS/Arch: linux/amd64

etcdctl --version:
  etcdctl version: 3.1.8̨
  API version: 2

docker --version =   Docker version 1.12.6, build 78d1802

kubernetes v1.7.0

/usr/local/flanneld --version =  v0.8.0-rc1-8-g4bc6cb2 ```

## to start
``` vagrant up ```

you can control k8z master from master node or from host machine that vagrant is running on.


## to do
- [] kube-dns.
