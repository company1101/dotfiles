NVIM_PYTHON2_VERSION := 2.7.16
NVIM_PYTHON3_VERSION := 3.7.3
ANACONDA_VERSION := 5.3.1
GO_VERSION := 1.13.1
DART_VERSION := 2.14
TMUX_VERSION := 2.9
HUB_VERSION := 2.12.8
KUBERNETES_VERSION := 1.16.4
HELM_VERSION := 3.1.1
STERN_VERSION := 1.11.0
K9S_VERSION := 0.9.3
KIND_VERSION := 0.7.0
FD_VERSION := 7.5.0
NVM_VERSION := 0.35.3
NODE_VERSION := 12.16.2

MISC_INSTALL_DIR := /usr/local/bin
BASH_GIT_PROMPT_DIR := $(HOME)/.bash-git-prompt
PYENV_DIR=$(HOME)/.pyenv
PYENV_VIRTUALENV_DIR=$(PYENV_DIR)/plugins/pyenv-virtualenv
GOROOT := /usr/local/go
GOPATH := $(HOME)/go
FZF_DIR=$(HOME)/.fzf
TMUX_PLUGINS_DIR=$(HOME)/.tmux/plugins/tpm

GO := $(GOROOT)/bin/go
CURL := curl -sSLf
PYENV := $(PYENV_DIR)/bin/pyenv

all: \
	apt-misc \
	links \
	docker \
	hub \
	fd \
	tmux \
	fzf \
	nvim \
	go \
	anaconda \
	dart \
	node \
	cpp \
	k8scli \
	prompt

help:
	@echo "Select a target from the followings"
	@echo "    apt-misc    - instal a bunch of commands with apt"
	@echo "    links       - make symlinks of dotfiles"
	@echo "    docker      - install docker"
	@echo "    hub         - install hub v$(HUB_VERSION)"
	@echo "    fd          - install fd v$(FD_VERSION)"
	@echo "    tmux        - install tmux v$(TMUX_VERSION)"
	@echo "    fzf         - install fzf"
	@echo "    nvim        - install nvim"
	@echo "    go          - install go $(GO_VERSION)"
	@echo "    anaconda    - install anaconda3 v$(ANACONDA_VERSION)"
	@echo "    dart        - install dart"
	@echo "    node        - install node v$(NODE_VERSION) with nvm v$(NVM_VERSION)"
	@echo "    cpp         - install cpp lsp"
	@echo "    k8scli      - install k8s cli tools"
	@echo "    prompt      - install bash prompt scripts"

curl: /usr/bin/curl

/usr/bin/curl:
	sudo apt -y --no-install-recommends install /usr/bin/curl

git: /usr/bin/git

/usr/bin/git:
	sudo apt -y --no-install-recommends install /usr/bin/git

apt-misc: /usr/bin/curl git
	sudo apt -y purge unattended-upgrades
	sudo apt update
	sudo apt -y --no-install-recommends install \
		wget \
		screen \
		tig \
		htop \
		tree \
		jq \
		xsel \
		make \
		colordiff \
		ranger \
		build-essential \
		autotools-dev \
		automake \
		libevent-dev \
		xdg-utils \
		bison \
		flex \
		ncurses-dev \
		llvm \
		clang-tools-8 \
		clang-format-8 \
		compiz-plugins \
		compiz-plugins-extra \
		compizconfig-settings-manager \
		libnotify-bin \
		libssl-dev \
		zlib1g-dev \
		libbz2-dev \
		libreadline-dev \
		libsqlite3-dev \
		libncurses5-dev \
		libncursesw5-dev \
		xz-utils \
		tk-dev \
		libffi-dev \
		liblzma-dev \
		libasound2 \
		python-openssl
	if [ -z "uname -a | grep microsoft" ]; then \
		sudo apt -y --no-install-recommends install \
			vim-gnome \
			x11-apps \
			x11-utils \
			x11-xserver-utils \
			dbus-x11; \
	else \
		sudo apt -y --no-install-recommends install vim; \
	fi
	sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo apt -y --no-install-recommends install google-chrome-stable

links: bashrc $(HOME)/.gitconfig $(HOME)/.screenrc $(HOME)/.tmux.conf $(HOME)/.config/nvim $(HOME)/.vimrc

bashrc:
	if [ -f $(HOME)/.bashrc ]; then rm -f $(HOME)/.bashrc; fi
	if [ ! -L $(HOME)/.bashrc ]; then ln -s .bashrc $(HOME)/; fi

$(HOME)/.gitconfig:
	ln -s .gitconfig $(HOME)/

$(HOME)/.screenrc:
	ln -s .screenrc $(HOME)/

$(HOME)/.tmux.conf:
	ln -s .tmux.conf $(HOME)/

$(HOME)/.config/nvim:
	mkdir -p $(HOME)/.config
	ln -s nvim $(HOME)/.config/

$(HOME)/.vimrc:
	ln -s nvim/init.vim $(HOME)/.vimrc

docker: /usr/bin/docker

/usr/bin/docker: /usr/bin/curl
	sudo apt-get remove docker docker-engine docker.io containerd runc
	sudo sh -c "${CURL} https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt update
	sudo apt -y --no-install-recommends install \
		docker-ce \
		docker-ce-cli \
		apt-transport-https \
		ca-certificates \
		gnupg-agent \
		software-properties-common \
		containerd.io
	sudo groupadd docker
	sudo usermod -aG docker $${USER}

hub: $(MISC_INSTALL_DIR)/hub

$(MISC_INSTALL_DIR)/hub:
	sudo sh -c "$(CURL) https://github.com/github/hub/releases/download/v$(HUB_VERSION)/hub-linux-amd64-$(HUB_VERSION).tgz | \
		tar xz -C $(MISC_INSTALL_DIR) --strip-component=2"

fd: /usr/bin/fd

/usr/bin/fd:
	${CURL} https://github.com/sharkdp/fd/releases/download/v$(FD_VERSION)/fd-musl_$(FD_VERSION)_amd64.deb
	sudo dpkg -i fd-musl_$(FD_VERSION)_amd64.deb
	rm -f fd-musl_$(FD_VERSION)_amd64.deb

tmux: $(TMUX_PLUGINS_DIR)

$(MISC_INSTALL_DIR)/tmux:
	mkdir -p /tmp/tmux
	$(CURL) https://github.com/tmux/tmux/archive/$(TMUX_VERSION).tar.gz | tar xz -C /tmp/tmux --strip-components=1
	cd /tmp/tmux && sh autogen.sh && ./configure && make && sudo make install

$(TMUX_PLUGINS_DIR):
	git clone https://github.com/tmux-plugins/tpm $(TMUX_PLUGINS_DIR)

fzf: $(FZF_DIR)

$(FZF_DIR):
	git clone https://github.com/junegunn/fzf.git $(FZF_DIR) && $(FZF_DIR)/install

go: \
	$(GOROOT) \
	$(GOPATH)/bin/ghq \
	$(GOPATH)/bin/goimports \
	$(GOPATH)/bin/golint \
	$(GOPATH)/bin/gorename \
	$(GOPATH)/bin/goreturns \
	$(GOPATH)/bin/gopls \
	$(GOPATH)/bin/cobra

$(GOROOT):
	sudo mkdir $(GOROOT)
	sudo sh -c "$(CURL) https://dl.google.com/go/go$(GO_VERSION).linux-amd64.tar.gz | tar xz -C $(GOROOT) --strip-components=1"
	mkdir -p $(GOPATH)/src $(GOPATH)/bin $(GOPATH)/pkg

$(GOPATH)/bin/ghq:
	GO111MODULE=off ${GO} get -u github.com/x-motemen/ghq

$(GOPATH)/bin/goimports:
	GO111MODULE=off ${GO} get -u golang.org/x/tools/cmd/goimports

$(GOPATH)/bin/golint:
	GO111MODULE=off ${GO} get -u golang.org/x/lint/golint

$(GOPATH)/bin/gorename:
	GO111MODULE=off ${GO} get -u golang.org/x/tools/cmd/gorename

$(GOPATH)/bin/goreturns:
	GO111MODULE=off ${GO} get -u sourcegraph.com/sqs/goreturns

$(GOPATH)/bin/gopls:
	cd /tmp && GO111MODULE=on ${GO} get golang.org/x/tools/gopls@latest

$(GOPATH)/bin/cobra:
	GO111MODULE=off ${GO} get -u github.com/spf13/cobra/cobra

dart: /usr/bin/dart $(HOME)/dart/flutter

/usr/bin/dart:
	sudo sh -c "${CURL} https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -"
	sudo sh -c "${CURL} https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list"
	sudo apt update
	sudo apt -y --no-install-recommends install dart apt-transport-https

$(HOME)/dart/flutter:
	mkdir -p $@
	git clone https://github.com/flutter/flutter.git $@ -b stable

node: $(HOME)/.nvm/versions/node/v$(NODE_VERSION)/bin/node

$(HOME)/.nvm:
	$(CURL) https://raw.githubusercontent.com/nvm-sh/nvm/v$(NVM_VERSION)/install.sh | bash

$(HOME)/.nvm/versions/node/v$(NODE_VERSION)/bin/node: $(HOME)/.nvm
	. $(HOME)/.nvm/nvm.sh && nvm install $(NODE_VERSION)

anaconda: $(PYENV_DIR)/versions/anaconda3-$(ANACONDA_VERSION)

$(PYENV_DIR)/versions/anaconda3-$(ANACONDA_VERSION): $(PYENV_DIR)
	pyenv install anaconda3-$(ANACONDA_VERSION)
	pyenv global anaconda3-$(ANACONDA_VERSION)

$(PYENV_DIR):
	git clone https://github.com/pyenv/pyenv.git $@
	eval "$$($(PYENV) init -)"

$(PYENV_VIRTUALENV_DIR):
	git clone https://github.com/pyenv/pyenv-virtualenv.git $@

cpp:
	sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 100

k8scli: \
	$(MISC_INSTALL_DIR)/kubectl \
	$(MISC_INSTALL_DIR)/helm \
	$(MISC_INSTALL_DIR)/stern \
	$(MISC_INSTALL_DIR)/k9s \
	$(MISC_INSTALL_DIR)/kind \
	$(HOME)/.krew

neovim: /usr/bin/nvim

/usr/bin/nvim: $(PYENV_DIR)/versions/$(NVIM_PYTHON2_VERSION) $(PYENV_DIR)/versions/$(NVIM_PYTHON3_VERSION)
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update
	sudo apt -y --no-install-recommends install neovim

$(PYENV_DIR)/versions/$(NVIM_PYTHON2_VERSION): $(PYENV_DIR) $(PYENV_VIRTUALENV_DIR)
	$(PYENV) install -s ${NVIM_PYTHON2_VERSION}
	$(PYENV) rehash
	$(PYENV) virtualenv ${NVIM_PYTHON2_VERSION} neovim2
	$(PYENV) global neovim2
	pip install neovim

$(PYENV_DIR)/versions/$(NVIM_PYTHON3_VERSION): $(PYENV_DIR) $(PYENV_VIRTUALENV_DIR)
	$(PYENV) install -s ${NVIM_PYTHON3_VERSION}
	$(PYENV) rehash
	$(PYENV) virtualenv ${NVIM_PYTHON3_VERSION} neovim3
	$(PYENV) global neovim3
	pip install neovim
	pip install pyls

$(MISC_INSTALL_DIR)/kubectl:
	sudo $(CURL) https://storage.googleapis.com/kubernetes-release/release/v$(KUBERNETES_VERSION)/bin/linux/amd64/kubectl -o $@
	sudo chmod 755 $@

$(MISC_INSTALL_DIR)/helm:
	sudo sh -c "$(CURL) https://get.helm.sh/helm-v$(HELM_VERSION)-linux-amd64.tar.gz | tar xz -C $(MISC_INSTALL_DIR) --strip-components=1"
	sudo chmod 755 $@

$(MISC_INSTALL_DIR)/stern:
	sudo $(CURL) https://github.com/wercker/stern/releases/download/$(STERN_VERSION)/stern_linux_amd64 -o $@
	sudo chmod 755 $@

$(MISC_INSTALL_DIR)/kind:
	sudo $(CURL) https://github.com/kubernetes-sigs/kind/releases/download/v$(KIND_VERSION)/kind-linux-amd64 -o $@
	sudo chmod 755 $@

$(MISC_INSTALL_DIR)/k9s:
	sudo sh -c "$$(echo \
		"$(CURL) https://github.com/derailed/k9s/releases/download/$(K9S_VERSION)/k9s_$(K9S_VERSION)_Linux_x86_64.tar.gz |" \
		"tar xz -C $(MISC_INSTALL_DIR)")"

$(HOME)/.krew:
	set -x; cd "$(mktemp -d)" && \
		$(CURL) -O "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
		tar zxvf krew.tar.gz && \
		KREW=./krew-"$$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
		"$${KREW}" install --manifest=krew.yaml --archive=krew.tar.gz && \
		"$${KREW}" update

prompt: $(BASH_GIT_PROMPT_DIR) $(HOME)/.kube-ps1 $(HOME)/.git-completion.bash

$(BASH_GIT_PROMPT_DIR):
	git clone https://github.com/magicmonty/bash-git-prompt.git $@ --depth=1

$(HOME)/.kube-ps1:
	$(CURL) https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh -o $@

$(HOME)/.git-completion.bash:
	${CURL} https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $@

.PHONY: \
	bashrc \
	apt-misc \
	links \
	docker \
	hub \
	fd \
	tmux \
	fzf \
	nvim \
	go \
	anaconda \
	dart \
	node \
	cpp \
	k8scli \
	prompt