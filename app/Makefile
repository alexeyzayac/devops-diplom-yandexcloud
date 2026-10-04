# ./app/Makefile

-include Makefile.vars

REGISTRY-ID ?= changeme
IMAGE_NAME  ?= diplom-app
TAG         ?= v1

DOCKERFILE  := app.Dockerfile
IMAGE       := cr.yandex/$(REGISTRY-ID)/$(IMAGE_NAME):$(TAG)	

.PHONY: up down

up:
	docker builder prune -af
	docker build -f $(DOCKERFILE) --provenance=false --sbom=false -t $(IMAGE) .
	docker push $(IMAGE)
	yc container image list --registry-id $(REGISTRY-ID)

down:
	-docker rmi $(IMAGE)
	-yc container image list --registry-id $(REGISTRY-ID) --format json \
		| jq -r '.[] | select(.name | endswith("/$(IMAGE_NAME)")) | .id' \
		| xargs -r -I{} yc container image delete {}