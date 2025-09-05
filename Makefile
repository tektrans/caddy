LOCAL_TAG := localhost/caddy
BASE_IMAGE := docker.io/library/caddy
VERSION := 2.10

DESCRIPTION := Custom caddyserver container with some modules added
VENDOR := TEKTRANS
MAINTAINER := Adhidarma Hadiwinoto <adhisimon@tektrans.id>
URL := https://github.com/tektrans/caddy

BUILD_CONTAINER_ARGS=\
	$(PODMAN_ARGS) $(PODMAN_BUILD_ARGS) \
	--annotation=org.opencontainers.image.description="${DESCRIPTION}" \
	--annotation=org.opencontainers.image.version="${VERSION}" \
	--annotation=org.opencontainers.image.revision="${REVISION}" \
	--annotation=org.opencontainers.image.url="${URL}" \
	--annotation=org.opencontainers.image.source="${URL}" \
	--annotation=org.opencontainers.image.authors="${MAINTAINER}" \
	--annotation=org.opencontainers.image.vendor="${VENDOR}" \
	-t ${LOCAL_TAG}:${VERSION}

build:
	make prepare-build
	podman build $(BUILD_CONTAINER_ARGS) .

pull-base-image:
	podman image pull ${BASE_IMAGE}:${VERSION}

prepare-build:
	rm -f Dockerfile 
	make Dockerfile
	make pull-base-image

Dockerfile: Makefile Dockerfile.template
	jinja \
		-D BASE_IMAGE "${BASE_IMAGE}" \
		-D VERSION "${VERSION}" \
		-D VENDOR "${VENDOR}" \
		-D DESCRIPTION "${DESCRIPTION}" \
		-D MAINTAINER "${MAINTAINER}" \
		-D URL "${URL}" \
		Dockerfile.template > Dockerfile
