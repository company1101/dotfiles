CURL := curl -sSfL

TMUX_VERSION := 2.9
HUB_VERSION := 2.12.8
FD_VERSION := 8.1.0
DELTA_VERSION := 0.6.0

PACKAGES := \
	tmux \
	fd-find \
	bat \
	jq \
	tree \
	htop \
	colordiff \
	firefox \
	xsel \
	openssl \
	gnupg \
	ca-certificates \
	build-essential

HOME_BIN_DIR := $(HOME)/bin
JQ := /usr/bin/jq
TMUX := $(HOME_BIN_DIR)/tmux
TMUX_PLUGINS_DIR := $(HOME)/.tmux/plugins/tpm
HUB := $(HOME_BIN_DIR)/hub
GH := /usr/bin/gh
FD := /usr/bin/fd
DELTA := /usr/bin/delta
NAVI := $(HOME_BIN_DIR)/navi
FZF_DIR := $(HOME)/.fzf
STARSHIP := $(HOME_BIN_DIR)/starship
NODE := /usr/local/bin/node
YARN := /usr/bin/yarn
BASH_GIT_PROMPT_DIR := $(HOME)/.bash-git-prompt
BASH_COMPLETION_PATH := $(HOME)/.git-completion.bash

.PHONY: install
install: \
	apt \
	tmuxplugins \
	hub \
	gh \
	fzf \
	delta \
	navi \
	starship \
	node \
	yarn \
	completion

.PHONY: apt
apt:
	sudo apt-get install -y --no-install-recommends $(PACKAGES)

.PHONY: tmuxplugins
tmuxplugins: $(TMUX_PLUGINS_DIR)
$(TMUX_PLUGINS_DIR):
	git clone https://github.com/tmux-plugins/tpm $@

.PHONY: hub
hub: $(HUB)
$(HUB):
	mkdir -p $(HOME_BIN_DIR)
	sudo sh -c "$(CURL) https://github.com/github/hub/releases/download/v$(HUB_VERSION)/hub-linux-amd64-$(HUB_VERSION).tgz | \
		tar xz -C $(HOME_BIN_DIR) --strip-component=2"

.PHONY: gh
gh: $(GH)
$(GH):
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt-get update
	sudo apt-get install -y --no-install-recommends gh

.PHONY: fzf
fzf: $(FZF_DIR)
$(FZF_DIR):
	git clone https://github.com/junegunn/fzf.git $(FZF_DIR) && \
		$(FZF_DIR)/install --no-key-bindings --no-completion --no-update-rc

.PHONY: starship
starship: $(STARSHIP)
$(STARSHIP):
	mkdir -p $(HOME_BIN_DIR)
	$(CURL) https://starship.rs/install.sh -o /tmp/starship_install.sh
	bash /tmp/starship_install.sh -y -b $(HOME_BIN_DIR)

.PHONY: delta
delta: $(DELTA)
$(DELTA):
	$(CURL) -o /tmp/delta.deb https://github.com/dandavison/delta/releases/download/$(DELTA_VERSION)/git-delta_$(DELTA_VERSION)_amd64.deb
	sudo dpkg -i /tmp/delta.deb

.PHONY: navi
navi: $(NAVI)
$(NAVI):
	$(CURL) https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install -o /tmp/navi.sh
	chmod +x /tmp/navi.sh
	BIN_DIR=$(HOME_BIN_DIR) bash /tmp/navi.sh

.PHONY: completion
completion: $(BASH_COMPLETION_PATH)
$(BASH_COMPLETION_PATH):
	${CURL} https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $@

.PHONY: node
node: $(NODE)
$(NODE):
	sudo apt-get -y --no-install-recommends install npm
	sudo npm i -g n
	sudo n $(NODE_VERSION)

.PHONY: yarn
yarn: $(YARN)
$(YARN): $(NODE)
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt update
	sudo apt install -y --no-install-recommends yarn

.PHONY: clean
clean:
	sudo apt-get purge -y $(PACKAGES) gh
	sudo dpkg -P delta
	rm -rf $(TMUX_PLUGIN_DIR)
	rm -f $(HUB)
	rm -rf $(FZF_DIR)
	rm -f $(STARSHIP)
	rm -f $(BASH_COMPLETION_PATH)
	sudo rm -rf $(NODE)
