IMAGE_TAG    := 0.1.0
IMAGE_REPO   := ghcr.io/getupcloud/x509-exporter-discovery
IMAGE_NAME   := $(IMAGE_REPO):$(IMAGE_TAG)
IMAGE_LATEST := $(IMAGE_REPO):latest

build:
	docker build . -t $(IMAGE_NAME)

tag:
	git tag v$(IMAGE_TAG)

push:
	docker push $(IMAGE_NAME)
	docker push $(IMAGE_LATEST)
	git push --tags

release: build tag push
