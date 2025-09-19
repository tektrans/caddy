# Custom caddy2 container image build by TEKTRANS

Custom [caddyserver](https://caddyserver.com) container (podman, docker, and so on) with some modules added
build by [TEKTRANS](https://www.tektrans.id/).
Based on [Caddy2 Docker Official Image](https://hub.docker.com/_/caddy).

- [Custom caddy2 container image build by TEKTRANS](#custom-caddy2-container-image-build-by-tektrans)
  - [Motivation](#motivation)
  - [Repository](#repository)
  - [How to pull](#how-to-pull)
  - [How to run it](#how-to-run-it)
    - [Podman quadlet example](#podman-quadlet-example)
  - [Modules added:](#modules-added)
  - [Other information and how to customize](#other-information-and-how-to-customize)

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
```bash
podman pull ghcr.io/tektrans/caddy:latest
```

Docker:
```bash
docker pull ghcr.io/tektrans/caddy:latest
```

If you want to lock to specific minor release (recommended, for compability reason), you can use image tag. Example:
Podman:
```bash
podman pull ghcr.io/tektrans/caddy:2.10
```

Docker:
```bash
docker pull ghcr.io/tektrans/caddy:2.10
```

## How to run it
This image is just extending original caddy container. You can use it as a drop-in replacement.
Just replace `docker.io/library/caddy` to `ghcr.io/tektrans/caddy`.
All steps to run and configure is the same with running and configuring original
caddy docker container.

Create Caddyfile on your container host, for example at /etc/caddy/Caddyfile. Then run:

```bash
podman run --rm --name caddy --tz Asia/Jakarta -p 80:80 -p 443:443 -p 443:443/udp ghcr.io/tektrans/caddy:2.10
```

**Note:**

You must run as root (or use *sudo*), because it needs to publish on port 80 and 443 (privilege ports).
Unless you set it to unprivileges ports and use some port forwarding techniques.

### Podman quadlet example
If your system support podman quadlet (indication: there is /etc/containers/systemd directory),
you can create this file on /etc/containers/systemd/caddy.container.

```systemd
# /etc/containers/systemd/caddy.container
[Unit]
After=network-online.target

[Container]
ContainerName=caddy
Image=ghcr.io/tektrans/caddy:2.10

## Set AutoUpdate to registry, so podman-auto-update.service will update image automatically
## Don't forget to enable podman-auto-update.timer
AutoUpdate=registry

## Needed to listen privileged ports
AddCapability=NET_ADMIN

## Publish HTTP port
PublishPort=80:80

## Publish HTTPS port
PublishPort=443:443

## Publish HTTP/3 port 
PublishPort=443:443/udp

Timezone=Asia/Jakarta

## Don't forget to create /etc/caddy/Caddyfile on container host
Volume=/etc/caddy:/etc/caddy:Z

## This is where caddy puts data like certificate files.
Volume=caddy_data:/data

## This is where caddy puts autosave caddy config in JSON.
Volume=caddy_config:/config

## Optional, ignore this if you don't need to store logs on persistent volume
Volume=caddy_log:/log

[Service]
ExecReload=/usr/bin/podman exec -w /etc/caddy caddy caddy reload
Restart=always

[Install]
## To start it on boot automatically
WantedBy=default.target
```

You can start/stop/restart by running:
```bash
sudo systemctl start caddy.service
```

```bash
sudo systemctl stop caddy.service
```

```bash
sudo systemctl restart caddy.service
```

If you change Caddyfile, you don't need restart this container, just reload the service by:

```bash
sudo systemctl reload caddy.service
```

Or if you want to validate your Caddyfile before reloading service:
```bash
sudo podman exec -ti caddy caddy validate --config=/etc/caddy/Caddyfile
```

## Modules added:
- [RFC2136](https://github.com/caddy-dns/rfc2136), provides ACME DNS challenge using RFC2136 Dynamic Updates.
- [s3-proxy](https://github.com/lindenlab/caddy-s3-proxy), allow to proxy request directly from S3.
- [caddy-fs-s3](https://github.com/sagikazarmark/caddy-fs-s3), provides virtual filesystem module
  for AWS S3 (and compatible) object store.

See ["list-modules.txt"](./list-modules.txt) to see all of included modules.

## Other information and how to customize
Please see base/upstream of this image at [Caddy2 Docker Official Image](https://hub.docker.com/_/caddy).
