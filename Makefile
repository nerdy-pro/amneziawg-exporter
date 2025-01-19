.PHONY: install uninstall reload
.EXPORT_ALL_VARIABLES:

PROJECT_NAME        ?= amneziawg-exporter
VERSION             := 1.1.1

DOCKER_BUILDKIT     ?= 1
BUILD_DIR           :=
INSTALL_BIN_DIR     := $(BUILD_DIR)/usr/bin
INSTALL_CONF_DIR    := $(BUILD_DIR)/etc
INSTALL_SYSTEMD_DIR := $(BUILD_DIR)/etc/systemd/system

install:
	@echo "Installing amneziawg-exporter..."
	install -Dm755 src/exporter.py $(INSTALL_BIN_DIR)/amneziawg-exporter
	install -Dm644 etc/amneziawg-exporter.env $(INSTALL_CONF_DIR)/amneziawg-exporter.env
	install -Dm644 etc/amneziawg-exporter.service $(INSTALL_SYSTEMD_DIR)/amneziawg-exporter.service

uninstall:
	@echo "Uninstalling amneziawg-exporter..."
	rm -f $(INSTALL_BIN_DIR)/amneziawg-exporter
	rm -f $(INSTALL_CONF_DIR)/amneziawg-exporter.env
	rm -f $(INSTALL_SYSTEMD_DIR)/amneziawg-exporter.service

reload:
	@echo "Reloading systemd daemon..."
	systemctl daemon-reload
	@echo "Systemd daemon reloaded."

include deb/deb.mk
include docker.mk
