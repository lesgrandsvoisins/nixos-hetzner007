# Build the gv-keycloakify Keycloak theme and package it with Nix.
#
#   make            build the theme jar, copy it here, build the Nix package
#   make theme      only rebuild the jar and copy it into gv-keycloakify/
#   make nix        only build the Nix package from the jar already here
#   make bump       increment the patch version in gv-keycloakify.nix
#   make release    theme + bump + nix
#   make clean      remove the Nix result symlink

KEYCLOAKIFY_DIR ?= ../../../../keycloakify-keygvje
KEYCLOAKIFY_DIR := $(abspath $(KEYCLOAKIFY_DIR))
JAR             := keycloak-theme-for-kc-26.2-and-above.jar
DEST            := gv-keycloakify/$(JAR)

NIXFILE := gv-keycloakify.nix

.PHONY: all release theme bump nix clean

all: theme nix

release: theme bump nix

# Needs node/npm and maven on PATH (e.g. nix-shell -p nodejs maven).
theme:
	cd $(KEYCLOAKIFY_DIR) && npm install && npm run build-keycloak-theme
	cp -f $(KEYCLOAKIFY_DIR)/dist_keycloak/$(JAR) $(DEST)

bump:
	@perl -i -pe 's/^(\s*version = "\d+\.\d+\.)(\d+)(";)/$$1.($$2+1).$$3/e' $(NIXFILE)
	@grep -n 'version = ' $(NIXFILE)

nix:
	nix-build gv-keycloakify.nix -o result-keycloakify

clean:
	rm -f result-keycloakify
