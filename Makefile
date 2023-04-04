comma := ,
space :=
space +=
IMAGE ?= hashtable/tahoe-lafs
VERSION=1.18.0
PYTHON_VERSION=3.10.10
ALPINE_VERSION=3.17
DEBIAN_DIST=bullseye
ALPINE_PLATFORMS ?= linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64/v8
DEBIAN_PLATFORMS ?= linux/amd64,linux/arm/v7,linux/arm64/v8
BUILD_TOOL ?= podman

alpine-platform-list := $(subst $(comma),$(space),${ALPINE_PLATFORMS})
debian-platform-list := $(subst $(comma),$(space),${DEBIAN_PLATFORMS})
alpine-tag = ${VERSION}-python${PYTHON_VERSION}-alpine${ALPINE_VERSION}
debian-tag = ${VERSION}-python${PYTHON_VERSION}-debian-${DEBIAN_DIST}

build-alpine-args = --platform=$(1) -f Containerfile.alpine --build-arg VERSION=${VERSION} --build-arg PYTHON_VERSION=${PYTHON_VERSION} --build-arg ALPINE_VERSION=${ALPINE_VERSION} -t ${IMAGE}:$(alpine-tag)-$(subst /,-,$(1)) .
build-debian-args = --platform=$(1) -f Containerfile.debian --build-arg VERSION=${VERSION} --build-arg PYTHON_VERSION=${PYTHON_VERSION} --build-arg DEBIAN_DIST=${DEBIAN_DIST} -t ${IMAGE}:$(debian-tag)-$(subst /,-,$(1)) .

.PHONY: build-all
build-all: $(BUILD_TOOL)-build-all

.PHONY: build-alpine
build-alpine: $(BUILD_TOOL)-build-alpine

.PHONY: build-debian
build-debian: $(BUILD_TOOL)-build-debian

.PHONY: push-all
push-all: $(BUILD_TOOL)-push-all

.PHONY: push-alpine
push-alpine: $(BUILD_TOOL)-push-alpine

.PHONY: push-debian
push-debian: $(BUILD_TOOL)-push-debian

include podman.mk docker.mk
