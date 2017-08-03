base:
  'etcd*':
    - etcd
  'k8z-master*':
    - flanneld
    - k8z.master
  'k8z-minion*':
    - docker
    - flanneld
    - k8z.worker
