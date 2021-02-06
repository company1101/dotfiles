CURL := curl -sSfL

KUBERNETES_VERSION := 1.16.4
KIND_VERSION := 0.7.0
HELM_VERSION := 3.5.1
KUSTOMIZE_VERSION := 3.5.4

HOME_BIN_DIR := $(HOME)/bin
KUBECTL := $(HOME_BIN_DIR)/kubectl
KIND := $(HOME_BIN_DIR)/kind
KUSTOMIZE := $(HOME_BIN_DIR)/kustomize
HELM := $(HOME_BIN_DIR)/helm

.PHONY: install
install: \
	kubectl \
	kind \
	kustomize \
	helm \

.PHONY: kubectl
kubectl: $(KUBECTL)
$(KUBECTL):
	mkdir -p $(HOME_BIN_DIR)
	sudo $(CURL) https://storage.googleapis.com/kubernetes-release/release/v$(KUBERNETES_VERSION)/bin/linux/amd64/kubectl -o $@
	sudo chmod 755 $@

.PHONY: kind
kind: $(KIND)
$(KIND):
	mkdir -p $(HOME_BIN_DIR)
	sudo $(CURL) https://github.com/kubernetes-sigs/kind/releases/download/v$(KIND_VERSION)/kind-linux-amd64 -o $@
	sudo chmod 755 $@

.PHONY: kustomize
kustomize: $(KUSTOMIZE)
$(KUSTOMIZE):
	mkdir -p $(HOME_BIN_DIR)
	sudo sh -c "$$(echo \
		"$(CURL) https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv$(KUSTOMIZE_VERSION)/kustomize_v$(KUSTOMIZE_VERSION)_linux_amd64.tar.gz |" \
		"tar xz -C $(HOME_BIN_DIR)")"

.PHONY: helm
helm: $(HELM)
$(HELM):
	mkdir -p $(HOME_BIN_DIR)
	sudo sh -c "$(CURL) https://get.helm.sh/helm-v$(HELM_VERSION)-linux-amd64.tar.gz | tar xz -C $(HOME_BIN_DIR) --strip-components=1"
	sudo chmod 755 $@

.PHONY: clean
clean:
	rm -f $(KUBECTL) $(KIND) $(KUSTOMIZE) $(HELM)