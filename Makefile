COMMIT:=$(shell git rev-list -1 HEAD)

.PHONY: build-docker-image
build-docker-image:
	docker buildx build \
	--platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
	--tag josefuentes/namecheap-ddns-refresher:$(COMMIT) .


.PHONY: push-docker-image
push-docker-image:
	docker buildx build \
	--push \
	--platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
	--tag josefuentes/namecheap-ddns-refresher:$(COMMIT) .
