DOTFILES := $(HOME)/dotfiles

.PHONY: cargo claude dump-claude nvim tmux kitty zsh starship git gh ssh cursor vscode zed lazygit worktrunk herdr obsidian obsidian-plugins cursor-extensions vscode-extensions dump-extensions

OBSIDIAN_VAULT := $(HOME)/Documents/notes

# rustup-init comes from brew's rustup; .zshenv already sources ~/.cargo/env.
cargo:
	rustup-init -y --no-modify-path
	xargs -L 1 $(HOME)/.cargo/bin/cargo install --locked < $(DOTFILES)/cargo/crates.txt
	$(HOME)/.cargo/bin/espup install

claude:
	ln -v -F -s $(DOTFILES)/claude/skills $(HOME)/.claude/skills
	ln -v -F -s $(DOTFILES)/claude/rules $(HOME)/.claude/rules
	ln -v -F -s $(DOTFILES)/claude/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	$(DOTFILES)/claude/install.sh

dump-claude:
	jq 'del(.autoMode, .hooks)' $(HOME)/.claude/settings.json > $(DOTFILES)/claude/settings.json

nvim:
	ln -v -F -s $(DOTFILES)/nvim $(HOME)/.config/nvim

tmux:
	ln -v -F -s $(DOTFILES)/tmux $(HOME)/.config/tmux
	@if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		echo "Installing tpm..."; \
		git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm; \
	else \
		echo "tpm already installed"; \
	fi

kitty:
	ln -v -F -s $(DOTFILES)/kitty $(HOME)/.config/kitty

zsh:
	ln -v -F -s $(DOTFILES)/.zshenv $(HOME)/.zshenv
	ln -v -F -s $(DOTFILES)/zsh $(HOME)/.config/zsh

starship:
	ln -v -F -s $(DOTFILES)/starship $(HOME)/.config/starship

git:
	ln -v -F -s $(DOTFILES)/git $(HOME)/.config/git
	chmod +x $(DOTFILES)/git/templates/hooks/pre-push

gh:
	@mkdir -p $(HOME)/.config/gh
	ln -v -F -s $(DOTFILES)/gh/config.yml $(HOME)/.config/gh/config.yml

ssh:
	@mkdir -p -m 700 $(HOME)/.ssh
	ln -v -F -s $(DOTFILES)/ssh/config $(HOME)/.ssh/config

cursor:
	ln -v -F -s $(DOTFILES)/cursor/settings.json "$(HOME)/Library/Application Support/Cursor/User/settings.json"
	ln -v -F -s $(DOTFILES)/cursor/keybindings.json "$(HOME)/Library/Application Support/Cursor/User/keybindings.json"

vscode:
	ln -v -F -s $(DOTFILES)/vscode/settings.json "$(HOME)/Library/Application Support/Code/User/settings.json"
	ln -v -F -s $(DOTFILES)/vscode/keybindings.json "$(HOME)/Library/Application Support/Code/User/keybindings.json"

zed:
	ln -v -F -s $(DOTFILES)/zed $(HOME)/.config/zed

lazygit:
	ln -v -F -s $(DOTFILES)/lazygit $(HOME)/.config/lazygit

worktrunk:
	ln -v -F -s $(DOTFILES)/worktrunk $(HOME)/.config/worktrunk

herdr:
	ln -v -F -s $(DOTFILES)/herdr $(HOME)/.config/herdr
	herdr integration install claude

obsidian:
	ln -v -F -s $(DOTFILES)/obsidian/.obsidian.vimrc $(OBSIDIAN_VAULT)/.obsidian.vimrc
	@mkdir -p $(OBSIDIAN_VAULT)/.obsidian
	ln -v -F -s $(DOTFILES)/obsidian/.obsidian/hotkeys.json $(OBSIDIAN_VAULT)/.obsidian/hotkeys.json
	ln -v -F -s $(DOTFILES)/obsidian/.obsidian/appearance.json $(OBSIDIAN_VAULT)/.obsidian/appearance.json
	ln -v -F -s $(DOTFILES)/obsidian/.obsidian/community-plugins.json $(OBSIDIAN_VAULT)/.obsidian/community-plugins.json

obsidian-plugins:
	$(DOTFILES)/obsidian/install-plugins.sh $(OBSIDIAN_VAULT)

cursor-extensions:
	cat $(DOTFILES)/cursor/extensions.txt | xargs -L 1 cursor --install-extension

vscode-extensions:
	cat $(DOTFILES)/vscode/extensions.txt | xargs -L 1 code --install-extension

dump-extensions:
	cursor --list-extensions > $(DOTFILES)/cursor/extensions.txt
	code --list-extensions > $(DOTFILES)/vscode/extensions.txt
