# rump-nginx

Nginx packaging and supporting infrastructure for running as unikernels in
userspace, powered by [frankenlibc](https://github.com/justincormack/frankenlibc)
and [Rump Kernels](http://rumpkernel.org).

# docker hub

[Docker hub](https://registry.hub.docker.com/u/justincormack/rump-nginx/)

```
docker pull justincormack/rump-nginx
```

There is a default config file so you can run
```
docker run -d --cap-add NET_ADMIN -P justincormack/rump-nginx-lua
```
