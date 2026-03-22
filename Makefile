DOTFILES := $(HOME)/dotfiles

.PHONY: nvim tmux kitty zsh starship git cursor vscode cursor-extensions vscode-extensions dump-extensions

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

cursor:
	ln -v -F -s $(DOTFILES)/cursor/settings.json "$(HOME)/Library/Application Support/Cursor/User/settings.json"
	ln -v -F -s $(DOTFILES)/cursor/keybindings.json "$(HOME)/Library/Application Support/Cursor/User/keybindings.json"

vscode:
	ln -v -F -s $(DOTFILES)/vscode/settings.json "$(HOME)/Library/Application Support/Code/User/settings.json"
	ln -v -F -s $(DOTFILES)/vscode/keybindings.json "$(HOME)/Library/Application Support/Code/User/keybindings.json"

cursor-extensions:
	cat $(DOTFILES)/cursor/extensions.txt | xargs -L 1 cursor --install-extension

vscode-extensions:
	cat $(DOTFILES)/vscode/extensions.txt | xargs -L 1 code --install-extension

dump-extensions:
	cursor --list-extensions > $(DOTFILES)/cursor/extensions.txt
	code --list-extensions > $(DOTFILES)/vscode/extensions.txt
