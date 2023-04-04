.PHONY: docker-build-all
docker-build-all: docker-build-alpine docker-build-debian

.PHONY: docker-build-alpine
docker-build-alpine-targets := $(patsubst %,docker-build-alpine-%,$(alpine-platform-list))
.PHONY: $(docker-build-alpine-targets) docker-build-alpine
docker-build-alpine: $(docker-build-alpine-targets)
$(docker-build-alpine-targets): platform = $(subst docker-build-alpine-,,$@)
$(docker-build-alpine-targets):
	@echo FOO $(call manifest-alpine,$(platform))
	docker build $(call build-alpine-args,$(platform))
	docker manifest create -a ${IMAGE}:$(alpine-tag) $(call manifest-alpine,$(platform))

.PHONY: docker-build-debian
docker-build-debian-targets := $(patsubst %,docker-build-debian-%,$(debian-platform-list))
.PHONY: $(docker-build-debian-targets) docker-build-debian
docker-build-debian: $(docker-build-debian-targets)
$(docker-build-debian-targets): platform = $(subst docker-build-debian-,,$@)
$(docker-build-debian-targets):
	@echo FOO $(call manifest-debian,$(platform))
	docker build $(call build-debian-args,$(platform))
	docker manifest create -a ${IMAGE}:$(alpine-tag) $(call manifest-debian,$(platform))

.PHONY: docker-push-alpine
docker-push-alpine:
	docker manifest push ${IMAGE}:$(alpine-tag) docker://docker.io/${IMAGE}:$(alpine-tag)

.PHONY: docker-push-debian
docker-push-debian:
	docker manifest push ${IMAGE}:$(debian-tag) ${IMAGE}:$(debian-tag)

.PHONY: docker-push-all
docker-push-all: docker-push-alpine docker-push-debian

.PHONY: docker-clean
docker-clean: docker-rm-alpine-manifest docker-rm-debian-manifest

.PHONY: docker-rm-alpine-manifest
docker-rm-alpine-manifest:
	(docker manifest exists ${IMAGE}:$(alpine-tag) && docker manifest rm ${IMAGE}:$(alpine-tag)) || true

.PHONY: docker-rm-debian-manifest
docker-rm-debian-manifest:
	(docker manifest exists ${IMAGE}:$(debian-tag) && docker manifest rm ${IMAGE}:$(debian-tag)) || true
