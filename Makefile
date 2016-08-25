VERSION := $(shell git describe --tags --exact-match 2>/dev/null || echo latest)
DOCKERHUB_NAMESPACE ?= keitaro
IMAGE := ${DOCKERHUB_NAMESPACE}/ckan-datapusher:${VERSION}

build:
	docker build -t ${IMAGE} rootfs

push: build
	docker push ${IMAGE}
