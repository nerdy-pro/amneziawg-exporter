.PHONY: deb clean_deb_structure setup_deb_structure


BUILD_DIR           := $(PROJECT_NAME)
DEBIAN_DIR          := $(BUILD_DIR)/DEBIAN
PACKAGE_NAME        := $(PROJECT_NAME)
ARCH                := amd64
DEB_FILE            := $(PACKAGE_NAME)_$(VERSION)_$(ARCH).deb
INSTALL_BIN_DIR     := $(BUILD_DIR)$(INSTALL_BIN_DIR)
INSTALL_CONF_DIR    := $(BUILD_DIR)$(INSTALL_CONF_DIR)
INSTALL_SYSTEMD_DIR := $(BUILD_DIR)$(INSTALL_SYSTEMD_DIR)

deb: clean_deb_structure setup_deb_structure install
	@echo "Building .deb package..."
	mv $(INSTALL_CONF_DIR)/amneziawg-exporter.env $(INSTALL_CONF_DIR)/amneziawg-exporter.env.new
	dpkg-deb --build $(BUILD_DIR)
	mv $(BUILD_DIR).deb $(DEB_FILE)
	@echo "$(DEB_FILE) created successfully."

clean_deb_structure:
	@echo "Cleaning deb build structure..."
	rm -rf $(BUILD_DIR) $(DEB_FILE)
	@echo "Deb build structure cleaned."

setup_deb_structure:
	@echo "Setting up deb package structure..."
	mkdir -p $(INSTALL_BIN_DIR)
	mkdir -p $(INSTALL_CONF_DIR)
	mkdir -p $(INSTALL_SYSTEMD_DIR)
	mkdir -p $(DEBIAN_DIR)
	cp deb/control.in $(DEBIAN_DIR)/control
	echo "Package: $(PACKAGE_NAME)" >> $(DEBIAN_DIR)/control
	echo "Version: $(VERSION)" >> $(DEBIAN_DIR)/control
	cp deb/postinst $(DEBIAN_DIR)/postinst
	chmod 755 $(DEBIAN_DIR)/postinst
	@echo "Deb package structure set up."

docker-deb:
	docker build . -t exporter:deb-builder --target dpkg-builder
	$(eval _CONTANER_ID := $(shell docker create exporter:deb-builder))
	docker cp $(_CONTANER_ID):/build/$(DEB_FILE) .
	docker rm $(_CONTANER_ID)

