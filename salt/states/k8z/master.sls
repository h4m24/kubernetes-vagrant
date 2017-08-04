kube-worker-bins:
  cmd.run:
    - name:   |
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kube-apiserver -P /usr/bin/
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kube-controller-manager -P /usr/bin/
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kube-scheduler -P /usr/bin/
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl -P /usr/bin/
        chmod +x /usr/bin/kube*

kube-api-systemd:
  file.managed:
    - name: /etc/systemd/system/kube-api.service
    - contents:  |
        [Unit]
        Description=Kubernetes API Server
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        After=flanneld.service
        Requires=flanneld.service

        [Service]
        EnvironmentFile=/run/flannel/subnet.env
        ExecStart=/usr/bin/kube-apiserver \
          --admission-control=NamespaceLifecycle,LimitRanger,DefaultStorageClass,ResourceQuota \
          --advertise-address=192.168.80.10 \
          --allow-privileged=true \
          --apiserver-count=1 \
          --audit-log-maxage=30 \
          --audit-log-maxbackup=3 \
          --audit-log-maxsize=100 \
          --audit-log-path=/var/lib/audit.log \
          --authorization-mode=AlwaysAllow \
          --bind-address=0.0.0.0 \
          --enable-swagger-ui=true \
          --etcd-servers=http://etcd.vagrant:2379 \
          --event-ttl=1h \
          --insecure-bind-address=0.0.0.0 \
          --kubelet-https=true \
          --service-cluster-ip-range=${FLANNEL_NETWORK} \
          --service-node-port-range=30000-32767 \
          --token-auth-file=/vagrant/config/users.csv
          --v=2
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kube-api
  service.running:
    - name: kube-api


kube-controller-systemd:
  file.managed:
    - name: /etc/systemd/system/kube-controller.service
    - contents:  |
        [Unit]
        Description=Kubernetes Controller Manager
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        After=flanneld.service
        Requires=flanneld.service

        [Service]
        EnvironmentFile=/run/flannel/subnet.env
        ExecStart=/usr/bin/kube-controller-manager \
          --address=0.0.0.0 \
          --allocate-node-cidrs=false \
          --cluster-cidr=${FLANNEL_NETWORK} \
          --cluster-name=kubernetes \
          --master=http://192.168.80.10:8080 \
          --service-cluster-ip-range=${FLANNEL_NETWORK} \
          --v=2
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kube-controller
  service.running:
    - name: kube-controller


kube-scheduler-systemd:
  file.managed:
    - name: /etc/systemd/system/kube-scheduler.service
    - contents:  |
        [Unit]
        Description=Kubernetes Scheduler
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes

        [Service]
        ExecStart=/usr/bin/kube-scheduler \
          --leader-elect=true \
          --master=http://192.168.80.10:8080 \
          --v=2
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kube-scheduler
  service.running:
    - name: kube-scheduler
