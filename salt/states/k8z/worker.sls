# download
# install

kube-worker-bins:
  cmd.run:
    - name:   |
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubectl -P /usr/bin/
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kube-proxy -P /usr/bin/
        wget --quiet https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubelet -P /usr/bin/
        chmod +x /usr/bin/kube*

# systemd files
kubelet-config:
  file.managed:
    - name: /var/lib/kubelet/kubeconfig
    - makedirs: true
    - contents:  |
        current-context: vagrant-context
        apiVersion: v1
        clusters:
        - cluster:
            api-version: v1
            server: http://k8z-master.vagrant:8080
          name: vagrant-cluster
        contexts:
        - context:
            cluster: vagrant-cluster
            user: kube-admin
          name: vagrant-context
        kind: Config
        preferences:
          colors: true
        users:
        - name: kube-admin
          user:
            token: RSr8Q00v4vJZ9riztLJZ2UbGA3vnu3KP

Kubelet-systemd:
  file.managed:
    - name: /etc/systemd/system/kubelet.service
    - contents:  |
        [Unit]
        Description=Kubernetes Kubelet
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        After=docker.service
        After=flanneld.service
        Requires=docker.service
        Requires=flanneld.service

        [Service]
        ExecStart=/usr/bin/kubelet \
          --api-servers=http://k8z-master.vagrant:8080 \
          --allow-privileged=true \
          --cluster-domain=cluster.local \
          --cluster-dns=10.20.53.53 \
          --container-runtime=docker \
          --kubeconfig=/var/lib/kubelet/kubeconfig \
          --serialize-image-pulls=false \
          --register-node=true \
          --v=2
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kubelet
  service.running:
    - name: kubelet


kube-proxy-systemd:
  file.managed:
    - name: /etc/systemd/system/kube-proxy.service
    - contents:  |
        [Unit]
        Description=Kubernetes Kube Proxy
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes

        [Service]
        EnvironmentFile=/run/flannel/subnet.env
        ExecStart=/usr/bin/kube-proxy \
          --cluster-cidr=${FLANNEL_NETWORK} \
          --masquerade-all=true  \
          --proxy-mode=iptables \
          --v=2 \
          --master=http://k8z-master.vagrant:8080
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kube-proxy
  service.running:
    - name: kube-proxy
