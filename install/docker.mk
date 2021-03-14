CURL := curl -sSfL

DOCKER_VERSION := 20.10.3~3-0
DOCKER_COMPOSE_VERSION := 1.28.2
CONTAINERD_VERSION := 1.4.3-1

HOME_BIN_DIR := $(HOME)/bin
CONTAINERD := /usr/bin/containerd
DOCKER := /usr/bin/docker
DOCKERD := /usr/bin/dockerd
DOCKER_COMPOSE := $(HOME_BIN_DIR)/docker-compose
LAZYDOCKER := $(HOME_BIN_DIR)/lazydocker

DOCKER_PACKAGES := \
	curl \
	software-properties-common \
	ca-certificates \
	gnupg-agent \
	apt-transport-https

.PHONY: install
install: \
	docker \
	docker-compose

.PHONY: containerd
containerd: $(CONTAINERD)
$(CONTAINERD):
	sudo apt-get purge -y containerd runc
	$(CURL) -o /tmp/containerd.deb https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/containerd.io_$(CONTAINERD_VERSION)_amd64.deb
	sudo dpkg -i /tmp/containerd.deb

.PHONY: docker-cli
docker-cli: $(DOCKER)
$(DOCKER):
	sudo apt-get purge -y docker docker.io
	$(CURL) -o /tmp/docker-ce-cli.deb https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce-cli_$(DOCKER_VERSION)~ubuntu-focal_amd64.deb
	sudo dpkg -i /tmp/docker-ce-cli.deb

.PHONY: docker
docker: $(DOCKERD)
$(DOCKERD): $(CONTAINERD) $(DOCKER)
	sudo apt-get purge -y docker-engine
	$(CURL) -o /tmp/docker-ce.deb https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/docker-ce_$(DOCKER_VERSION)~ubuntu-focal_amd64.deb
	sudo dpkg -i /tmp/docker-ce.deb
	if ! grep -q docker /etc/group; then \
		sudo groupadd docker; \
	fi
	sudo usermod -aG docker $${USER}; \

.PHONY: docker-compose
docker-compose: $(DOCKER_COMPOSE)
$(DOCKER_COMPOSE):
	sudo $(CURL) https://github.com/docker/compose/releases/download/$(DOCKER_COMPOSE_VERSION)/docker-compose-$$(uname -s)-$$(uname -m) -o $@
	sudo chmod +x $@

.PHONY: lazydocker
lazydocker: $(LAZYDOCKER)
$(LAZYDOCKER):
	$(CURL) https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | env DIR=$(HOME_BIN_DIR) bash

.PHONY: clean
clean:
	echo "docker related executables are not cleaned"
	rm -f $(DOCKER_COMPOSE)
