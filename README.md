# caddy

Custom [caddyserver](https://caddyserver.com) container (podman, docker, and so on) with some modules added
build by [TEKTRANS](https://www.tektrans.id/).

## Motivation
Why we build this custom caddy container?
Main reason is we need to run caddy to serves content backed by S3 storage.

Another reason is we need to build a cluster of caddy.
RFC2316 allow this to run ACME on multiple server to get certificate for a hostname.

## Repository
Source code of Dockerfile template and other scripts can be found on
[GitHub](https://github.com/tektrans/caddy).

Container image publish and release publicly on this
[GitHub repository](https://github.com/orgs/tektrans/packages/container/package/caddy).

## How to pull
You can pull latest image by:

Podman:
```shell
podman pull ghcr.io/tektrans/caddy:latest
```

Docker:
```shell
docker pull ghcr.io/tektrans/caddy:latest
```

If you want to lock to specific minor release (recommended, for compability reason), you can use image tag. Example:
Podman:
```shell
podman pull ghcr.io/tektrans/caddy:2.10
```

Docker:
```shell
docker pull ghcr.io/tektrans/caddy:2.10
```

## Modules added:
- [RFC2136](https://github.com/caddy-dns/rfc2136), provides ACME DNS challenge using RFC2136 Dynamic Updates.
- [s3-proxy](https://github.com/lindenlab/caddy-s3-proxy), allow to proxy request directly from S3.
- [caddy-fs-s3](https://github.com/sagikazarmark/caddy-fs-s3), provides virtual filesystem module
  for AWS S3 (and compatible) object store.

See ["list-modules.txt"](./list-modules.txt) to see all of included modules.
