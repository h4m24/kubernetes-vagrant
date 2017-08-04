## to test kubernetes dns run the following
```kubectl create -f busybox.yaml```

#### test resolution of default name
```kubectl exec -ti busybox -- nslookup kubernetes.default```

### check the resolve conf file in container
```kubectl exec busybox cat /etc/resolv.conf```
