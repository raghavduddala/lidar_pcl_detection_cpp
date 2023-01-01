VERSION := 0.0.1
IMAGE := pcl-sensor-fusion
CONTAINER := ${IMAGE}:${VERSION}
XSOCK := /tmp/.X11-unix

.PHONY: help
help: ## Display the help message
		@grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:[[:blank:]]*\(##\)[[:blank:]]*/\1/' | column -s '##' -t

.PHONY: version
version: ## Display the version
		@echo $(VERSION)

# x11-unix network security forwarding required 
# for forwarding the GUI Applications
.PHONY: dev
dev: ## runs the env for open3d in the container
	@xhost +local:root 		
	@docker run --rm -it \
		--privileged \
		--env="DISPLAY" \
		--env="QT_X11_NO_MITSHM=1" \
		--env="TERM=xterm-256color" \
		--volume $(PWD):/workspace/ \
		--volume $(XSOCK):$(XSOCK) \
		--name $(IMAGE) \
		$(CONTAINER) \
		/bin/bash
	@xhost -local:root

.PHONY: shell
shell: ## attaches a shell to a currently running container
		@docker exec -ti \
		$(IMAGE) \
		/bin/bash

.PHONY: build
build: ## Builds the container image
		@DOCKER_BUILDKIT=1 docker build \
		--progress=plain \
		--tag $(CONTAINER) \
		.
