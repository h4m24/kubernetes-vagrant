### automatically resolve ingress names from host machine on any guest machine

- first make sure cluster is up, changing, `resolve.conf` before creating cluster may interfere with package installation.
- point your `resolve.conf` towards master node
- create any ingress on any minion and it will resolve any name on the minion name domain
