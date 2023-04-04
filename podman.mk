.PHONY: podman-build-all
podman-build-all: podman-build-alpine podman-build-debian

.PHONY: podman-manifest-alpine
podman-manifest-alpine: podman-rm-alpine-manifest
podman-manifest-alpine:
	podman manifest create ${IMAGE}:$(alpine-tag)

.PHONY: podman-manifest-debian
podman-manifest-debian: podman-rm-debian-manifest
podman-manifest-debian:
	podman manifest create ${IMAGE}:$(debian-tag)

.PHONY: podman-build-alpine
podman-build-alpine-targets := $(patsubst %,podman-build-alpine-%,$(alpine-platform-list))
.PHONY: $(podman-build-alpine-targets) podman-build-alpine
podman-build-alpine: podman-manifest-alpine $(podman-build-alpine-targets)
$(podman-build-alpine-targets): platform = $(subst podman-build-alpine-,,$@)
$(podman-build-alpine-targets):
	podman build --manifest=${IMAGE}:$(alpine-tag) --format=docker $(call build-alpine-args,$(platform))

.PHONY: podman-build-debian
podman-build-debian-targets := $(patsubst %,podman-build-debian-%,$(debian-platform-list))
.PHONY: $(podman-build-debian-targets) podman-build-debian
podman-build-debian: podman-manifest-debian $(podman-build-debian-targets)
$(podman-build-debian-targets): platform = $(subst podman-build-debian-,,$@)
$(podman-build-debian-targets):
	podman build --manifest=${IMAGE}:$(debian-tag) $(call build-debian-args,$(platform))

.PHONY: podman-push-alpine
podman-push-alpine:
	podman manifest push --all ${IMAGE}:$(alpine-tag) docker://docker.io/${IMAGE}:$(alpine-tag)

.PHONY: podman-push-debian
podman-push-debian:
	podman manifest push ${IMAGE}:$(debian-tag) ${IMAGE}:$(debian-tag)

.PHONY: podman-push-all
podman-push-all: podman-push-alpine podman-push-debian

.PHONY: podman-clean
podman-clean: podman-rm-alpine-manifest podman-rm-debian-manifest

.PHONY: podman-rm-alpine-manifest
podman-rm-alpine-manifest:
	(podman manifest exists ${IMAGE}:$(alpine-tag) && podman manifest rm ${IMAGE}:$(alpine-tag)) || true

.PHONY: podman-rm-debian-manifest
podman-rm-debian-manifest:
	(podman manifest exists ${IMAGE}:$(debian-tag) && podman manifest rm ${IMAGE}:$(debian-tag)) || true
