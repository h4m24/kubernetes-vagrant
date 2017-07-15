etcd-server:
  archive.extracted:
    - name: /opt/
    - source: https://github.com/coreos/etcd/releases/download/v3.1.8/etcd-v3.1.8-linux-amd64.tar.gz
    - skip_verify: true
    - options: xzf
    - archive_format: tar
    - if_missing: /opt/etcd-v3.1.8-linux-amd64
  file.copy:
    - name: /usr/bin/etcd
    - source: /opt/etcd-v3.1.8-linux-amd64/etcd
    - force: true

etcd-ctl:
  file.copy:
    - name: /usr/bin/etcdctl
    - source: /opt/etcd-v3.1.8-linux-amd64/etcdctl
    # - force: true



etcd-systemd-file:
  file.managed:
    - name: /etc/systemd/system/etcd.service
    - contents: |
        [Unit]
        Description=etcd
        Documentation=https://github.com/coreos/etcd
        Conflicts=etcd.service

        [Service]
        Type=notify
        Restart=always
        RestartSec=5s
        LimitNOFILE=40000
        TimeoutStartSec=0

        ExecStart=/usr/bin/etcd --name etcd-dev --listen-client-urls  http://0.0.0.0:2379 --advertise-client-urls http://etcd.vagrant:2379 
        ExecReload=/bin/kill -HUP $MAINPID
        KillSignal=SIGTERM

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: |
        systemctl enable etcd
        systemctl daemon-reload
  service.running:
    - name: etcd
    - watch:
      - file: /etc/systemd/system/etcd.service

flannel-etcd-config:
  file.managed:
    - name: /tmp/flannel-config.json
    - contents:  |
        {
            "Network": "10.20.0.0/16",
            "SubnetMin": "10.20.1.0",
            "SubnetMax": "10.20.10.0",
            "SubnetLen": 24,
            "Backend": { "Type": "vxlan", "VNI": 1}
        }
  cmd.run:
    - name: /usr/bin/etcdctl set kubernetes-cluster/network/config < /tmp/flannel-config.json
