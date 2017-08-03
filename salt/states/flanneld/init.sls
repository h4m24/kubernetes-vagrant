flannel-bin:
  file.managed:
    - name: /usr/local/flanneld
    - source: salt://flanneld/files/flanneld-amd64
    - mode: 0775


flanneld-systemd-file:
  file.managed:
    - name: /etc/systemd/system/flanneld.service
    - contents: |
        [Unit]
        Description=flanneld
        Documentation=https://github.com/coreos/flanneld
        Before=docker.service
        Conflicts=flanneld.service

        [Service]
        Type=notify
        Restart=always
        RestartSec=5s
        LimitNOFILE=40000
        TimeoutStartSec=0

        ExecStart=/usr/local/flanneld -etcd-endpoints http://etcd.vagrant:2379  -etcd-prefix "/kubernetes-cluster/network" -iface=enp0s8
        ExecReload=/bin/kill -HUP $MAINPID
        KillSignal=SIGTERM

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: |
        systemctl enable flanneld
        systemctl daemon-reload
  service.running:
    - name: flanneld
    - watch:
      - file: /etc/systemd/system/flanneld.service
# 
# configure-docker:
#   cmd.run:
#     - name: |
#         echo DOCKER_OPTS=$(cat /run/flannel/subnet.env | grep FLANNEL_SUBNET | awk -F"="  '{print $2}' | sed 's#/24##g')  >> /etc/default/docker
#         service docker restart
