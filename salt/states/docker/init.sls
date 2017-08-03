# install
docker-install:
  archive.extracted:
    - name: /opt/
    - source: https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz
    - skip_verify: true
    - options: xzf
    - archive_format: tar
    - if_missing: /opt/docker-1.12.6.tgz
  cmd.run:
    - name: cp /opt/docker/docker* /usr/bin/



docker-systemd:
  file.managed:
    - name: /etc/systemd/system/docker.service
    - contents:  |
        [Unit]
        Description=Docker Application Container Engine
        Documentation=http://docs.docker.io

        [Service]
        ExecStart=/usr/bin/docker daemon \
          --iptables=false \
          --ip-masq=false \
          --host=unix:///var/run/docker.sock \
          --log-level=error \
          --bip=10.20.5.1/24 \
          --mtu=1450 \
          --storage-driver=overlay
        Restart=on-failure
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
  cmd.run:
    - name: systemctl daemon-reload &&  systemctl enable docker
  service.running:
    - name: docker
