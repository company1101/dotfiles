# dotfiles

⚡⚡⚡

## OS

Ubuntu 20.04 on WSL2

## Install

### Ubuntu 20.04

```sh
sudo visudo
# tapih ALL=NOPASSWD: ALL

mkdir -m 700 ~/.ssh
cd ~/.ssh
ssh-keygen -t rsa -b 4096 -f github_rsa
# register the generated public key to GitHub

cat << EOF > config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_rsa
EOF

mkdir ~/src
cd ~/src
git clone git@github.com:tapih/dotfiles
cd dotfiles

sudo apt-get install -y make
make -f install/links.mk clean
make -f ubuntu.mk setup install WINDOWS_USER=<your name>

ZSH=/home/linuxbrew/.linuxbrew/bin/zsh
echo "$(ZSH)" | sudo tee -a /etc/shells
chsh -s $(ZSH)
```

Windows Terminal requires to disable `<C-v>` to work with `nvim`.

On Windows side, these tools should be installed manually.

- Chrome
- Mozc(+Swap Ctrl and Caps)
- Enpass
- Windows Terminal
- VcXsrv
- Powershell
- Android Studio
- Slack
- Notion
- Kindle
- Adobe XD
- Zoom

