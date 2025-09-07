# caddy

Custom [caddyserver](https://caddyserver.com) container with some modules added.

## Modules added:
- [RFC2136](https://github.com/caddy-dns/rfc2136), provides ACME DNS challenge using RFC2136 Dynamic Updates.
- [s3-proxy](https://github.com/lindenlab/caddy-s3-proxy), allow to proxy request directly from S3.
- [caddy-fs-s3](https://github.com/sagikazarmark/caddy-fs-s3), provides virtual filesystem module
  for AWS S3 (and compatible) object store.
