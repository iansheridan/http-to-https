DOCKER_BASE=iansheridan/http-to-https
DOCKER_TAG=1.0
$(eval GIT_COMMIT = $(shell git rev-parse HEAD))

ALPINE_VERSION=3.7

default: build

clean:
	rm -f Dockerfile

Dockerfile: Dockerfile.template
	sed \
		-e 's!{{ .AlpineVersion }}!'"$(ALPINE_VERSION)"'!g' \
		-e 's!{{ .Version }}!'"$(DOCKER_TAG)"'!g' \
		-e 's!{{ .GitCommit }}!'"$(GIT_COMMIT)"'!g' \
		Dockerfile.template > Dockerfile

build: Dockerfile
	docker build -t $(DOCKER_BASE):$(DOCKER_TAG) .

run: build
	docker run -it -p80:80 --rm $(DOCKER_BASE):$(DOCKER_TAG)

debug: build
	docker run -it -p80:80 --rm $(DOCKER_BASE):$(DOCKER_TAG) /bin/sh

push: build
	docker push $(DOCKER_BASE):$(DOCKER_TAG)
