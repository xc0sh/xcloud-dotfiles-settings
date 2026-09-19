# Variables
BIN_DIR = $(HOME)/.local/bin
LIB_DIR = $(HOME)/.local/share/xcloud-dotfiles-settings

install:
	@echo "Installing xcloud-dotfiles-settings..."
	mkdir -p $(BIN_DIR)
	mkdir -p $(LIB_DIR)

	@echo "Installing binary..."
	install -m 755 bin/xcloud-dotfiles-settings $(BIN_DIR)/

	@echo "Installing libraries..."
	# colors/colors.json is regenerated live by matugen; preserve it across
	# a reinstall instead of reverting it to the repo's static default.
	@if [ -f $(LIB_DIR)/colors/colors.json ]; then \
		OLD_COLORS=$$(cat $(LIB_DIR)/colors/colors.json); \
		cp -r lib/* $(LIB_DIR)/; \
		echo "$$OLD_COLORS" > $(LIB_DIR)/colors/colors.json; \
	else \
		cp -r lib/* $(LIB_DIR)/; \
	fi

	@echo "Installing demo profile..."
	mkdir -p $(LIB_DIR)/demo
	cp -r demo/* $(LIB_DIR)/demo/
	@echo "Done! Make sure $(BIN_DIR) is in your PATH."

uninstall:
	rm -f $(BIN_DIR)/xcloud-dotfiles-settings
	rm -rf $(LIB_DIR)
	@echo "Removed xcloud-dotfiles-settings."
