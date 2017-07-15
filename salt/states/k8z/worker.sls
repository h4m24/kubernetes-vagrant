# download
# install

kube-worker-bins:
  cmd.run:
    - name:   |
        wget https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubectl -P /usr/bin/
        wget https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kube-proxy -P /usr/bin/
        wget https://storage.googleapis.com/kubernetes-release/release/v1.6.1/bin/linux/amd64/kubelet -P /usr/bin/
        chmod +x /usr/bin/kube*

# systemd files
kubelet-config:
  file.managed:
    - name: /var/lib/kubelet/kubeconfig
    - makedirs: true
    - contents:  |
        current-context: federal-context
        apiVersion: v1
        clusters:
        - cluster:
            api-version: v1
            server: http://k8z-master.vagrant:8080
          name: cow-cluster
        contexts:
        - context:
            cluster: horse-cluster
            namespace: chisel-ns
            user: green-user
          name: federal-context
        kind: Config
        preferences:
          colors: true
        users:
        - name: blue-user
          user:
            token: blue-token


Kubelet-systemd:
  file.managed:
    - name: /etc/systemd/system/kubelet.service
    - contents:  |
        [Unit]
        Description=Kubernetes Kubelet
        Documentation=https://github.com/GoogleCloudPlatform/kubernetes
        After=docker.service
        Requires=docker.service

        [Service]
        ExecStart=/usr/bin/kubelet  --api-servers=http://k8z-master.vagrant:8080  --allow-privileged=true  --cluster-domain=cluster.local  --container-runtime=docker  --kubeconfig=/var/lib/kubelet/kubeconfig  --serialize-image-pulls=false  --register-node=true  --v=2
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
        ExecStart=/usr/bin/kube-proxy --cluster-cidr=10.20.0.0/16 --masquerade-all=true  --proxy-mode=iptables --v=2 --master=http://k8z-master.vagrant:8080
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable kube-proxy
  service.running:
    - name: kube-proxy
