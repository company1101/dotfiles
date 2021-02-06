CURL := curl -sSfL

GENIE := /usr/bin/genie
GENIE_VERSION := 1.34

PACKAGES := \
	apt-transport-https \
	dotnet-sdk-5.0 \
	daemonize \
	systemd-container \
	x11-apps \
	x11-utils \
	x11-xserver-utils \
	dbus-x11

.PHONY: install
install: genie

.PHONY: genie
genie: $(GENIE)
$(GENIE):
	$(CURL) https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -o /tmp/packages-microsoft-prod.deb
	sudo dpkg -i /tmp/packages-microsoft-prod.deb
	sudo apt-get update && \
		sudo apt-get install -y --no-install-recommends $(PACKAGES)
	$(CURL) -o /tmp/download.deb https://github.com/arkane-systems/genie/releases/download/$(GENIE_VERSION)/systemd-genie_$(GENIE_VERSION)_amd64.deb
	sudo dpkg -i /tmp/download.deb || true
	sudo apt-get --fix-broken install
	sudo dpkg -i /tmp/download.deb

.PHONY: clean
clean:
	sudo apt-get purge -y $(PACKAGES)
	sudo dpkg -P systemd-genie