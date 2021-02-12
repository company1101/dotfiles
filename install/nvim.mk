all: nvim-install

include python.mk

CURL := curl -sSfL

NODE_VERSION := 12.16.2

NVIM := /usr/bin/nvim
PYENV_VIRTUALENV_DIR=$(PYENV_DIR)/plugins/pyenv-virtualenv
NVIM2_DIR := $(PYENV_DIR)/versions/neovim2
NVIM3_DIR := $(PYENV_DIR)/versions/neovim3

.PHONY: nvim-install
nvim-install: \
	nvim \
	neovim2 \
	neovim3

.PHONY: nvim
nvim: $(NVIM)
$(NVIM):
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt-get update
	sudo apt-get -y --no-install-recommends install neovim

.PHONY: virtualenv
virtualenv: $(PYENV_VIRTUALENV_DIR)
$(PYENV_VIRTUALENV_DIR): $(PYENV_DIR)
	# The timestamp of pyenv is updated newer than virtualenv
	if [ ! -d $(PYENV_VIRTUALENV_DIR) ]; then \
		git clone https://github.com/pyenv/pyenv-virtualenv.git $@; \
	fi

.PHONY: neovim2
neovim2: $(NVIM2_DIR)
$(NVIM2_DIR): $(PYENV_VIRTUALENV_DIR) $(PYTHON2_DIR)
	$(PYENV) virtualenv $(PYTHON2_VERSION) neovim2
	CURRENT=$($(PYENV) global) && \
			$(PYENV) global neovim2 && \
			$(NVIM2_DIR)/bin/pip install -U pip && \
			$(NVIM2_DIR)/bin/pip install pynvim && \
			$(PYENV) global $${CURRENT}

.PHONY: neovim3
neovim3: $(NVIM3_DIR)
$(NVIM3_DIR): $(PYENV_VIRTUALENV_DIR) $(PYTHON3_DIR)
	$(PYENV) virtualenv $(PYTHON3_VERSION) neovim3
	CURRENT=$($(PYENV) global) && \
			$(PYENV) global neovim3 && \
			$(NVIM3_DIR)/bin/pip install -U pip && \
			$(NVIM3_DIR)/bin/pip install pynvim && \
			$(NVIM3_DIR)/bin/pip install keyring browser-cookie3 && \
			$(PYENV) global $${CURRENT}

.PHONY: nvim-clean
nvim-clean:
	sudo apt-get purge -y neovim vim yarn
	rm -rf $(PYENV_VIRTUALENV_DIR)
	rm -rf $(NVIM2_DIR)
	rm -rf $(NVIM3_DIR)

