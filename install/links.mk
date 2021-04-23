CURL := curl -sSfL

ROOT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..

ZSHRC := ${HOME}/.zshrc
ZSHRC_DIR := ${HOME}/.zshrc_dir
INPUTRC := ${HOME}/.inputrc
GITCONFIG := ${HOME}/.gitconfig
TMUX_CONF := ${HOME}/.tmux.conf
NVIMRC_DIR := ${HOME}/.config/nvim
VIMRC := ${HOME}/.vimrc
IDEAVIMRC := ${HOME}/.ideavimrc
STARSHIPRC := ${HOME}/.config/starship.toml

SKIP_TMUX ?=

.PHONY: install
install: \
	zshrc \
	zshrcdir \
	inputrc \
	gitconfig \
	tmuxrc \
	nvimrc \
	vimrc \
	ideavimrc \
	starshiprc

.PHONY: zshrc
zshrc: $(ZSHRC)
$(ZSHRC):
	ln -s $(ROOT_DIR)/zshrc $@

.PHONY: zshrcdir
zshrcdir: $(ZSHRC_DIR)
$(ZSHRC_DIR):
	ln -s $(ROOT_DIR)/zshrc_dir $@

.PHONY: inputrc
inputrc: $(INPUTRC)
$(INPUTRC):
	ln -s $(ROOT_DIR)/inputrc $@

.PHONY: gitconfig
gitconfig: $(GITCONFIG)
$(GITCONFIG):
	ln -s $(ROOT_DIR)/gitconfig $@

.PHONY: tmuxrc
tmuxrc: $(TMUX_CONF)
$(TMUX_CONF):
	if [ -z "${SKIP_TMUX}" ]; then
		ln -s $(ROOT_DIR)/tmux.conf $@
	fi

.PHONY: nvimrc
nvimrc: $(NVIMRC_DIR)
$(NVIMRC_DIR):
	mkdir -p ${HOME}/.config
	ln -s $(ROOT_DIR)/nvim $@

.PHONY: vimrc
vimrc: $(VIMRC)
$(VIMRC):
	ln -s $(ROOT_DIR)/nvim/init.vim $@

.PHONY: ideavimrc
ideavimrc: $(IDEAVIMRC)
$(IDEAVIMRC):
	ln -s $(ROOT_DIR)/ideavimrc $@

.PHONY: starshiprc
starshiprc: $(STARSHIPRC)
$(STARSHIPRC):
	ln -s $(ROOT_DIR)/config/starship.toml $@

.PHONY: clean
clean:
	rm -f $(ZSHRC)
	rm -rf $(ZSHRC_DIR)
	rm -f $(INPUTRC)
	rm -f $(GITCONFIG)
	rm -f $(TMUX_CONF)
	rm -rf $(NVIMRC_DIR)
	rm -f $(VIMRC)
	rm -f $(IDEAVIMRC)
	rm -f $(STARSHIPRC)

