install-dnsmasq:
  pkg.installed:
    - name: dnsmasq
  file.managed:
    - name:   /etc/dnsmasq.d/vagrant.conf
    - contents:   |
        address=/.k8z-minion-001.vagrant/192.168.80.20
        address=/.k8z-minion-002.vagrant/192.168.80.30
  service.running:
    - name: dnsmasq
    - watch:
      - file: /etc/dnsmasq.d/vagrant.conf
