base:
  'etcd*':
    - etcd
  'k8z-master*':
    - flanneld
    - k8z.master
    - flanneld
    - dnsmasq
  'k8z-minion*':
    - docker
    - flanneld
    - k8z.worker
