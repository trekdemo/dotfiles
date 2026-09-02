.PHONY: default install link unlink ensure_brew brew_bundle_install help

default: help

install: brew_bundle_install link

help:
	@echo "Available targets:"
	@echo "  install              - Run link, brew_bundle_install, and install_tmux_plugins"
	@echo "  link                 - Symlink dotfiles using stow (--adopt mode)"
	@echo "  unlink               - Remove dotfile symlinks"
	@echo "  ensure_brew          - Check if Homebrew is installed, install if missing"
	@echo "  brew_bundle_install  - Install Homebrew packages from Brewfile"

link:
	stow --adopt --target ~ home

unlink:
	stow --delete --target ~ home

ensure_brew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found. Installing Homebrew..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew is already installed"; \
	fi

brew_bundle_install: ensure_brew
	brew bundle install --file=./home/.Brewfile
