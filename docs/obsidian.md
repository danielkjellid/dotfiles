# Obsidian

Vault-agnostic Obsidian config: vim keybindings that mirror `~/.config/nvim`,
plus a small set of vault settings that are worth version-tracking.

The vault itself lives outside dotfiles (default: `~/Documents/notes`). This
folder only holds files that get symlinked *into* the vault.

## Files

| Path                                | What it is                                                       |
| ----------------------------------- | ---------------------------------------------------------------- |
| `.obsidian.vimrc`                   | Vim mappings loaded by the Vimrc Support plugin.                 |
| `.obsidian/community-plugins.json`  | List of community plugin IDs to install + enable.                |
| `.obsidian/hotkeys.json`            | Custom Obsidian hotkeys.                                         |
| `.obsidian/appearance.json`         | Theme, font, accent.                                             |
| `install-plugins.sh`                | Downloads each plugin in `community-plugins.json` from GitHub.   |

Not tracked: `workspace.json` (rewrites itself with note paths), `bookmarks.json`
(contains note paths), and the plugin source under `.obsidian/plugins/<id>/`
(open-source code, fetched by `install-plugins.sh`).

## First-time setup

```sh
make obsidian          # symlinks .obsidian.vimrc + tracked configs into the vault
make obsidian-plugins  # downloads community plugins listed in community-plugins.json
```

Then start Obsidian (or `Cmd-P → Reload app without saving`). The Vimrc Support
plugin loads `.obsidian.vimrc` on startup.

By default the vault path is `~/Documents/notes` (set in the `Makefile` via
`OBSIDIAN_VAULT`). Override per-run: `make obsidian OBSIDIAN_VAULT=/some/path`.

## Adding a plugin

1. Find the plugin's ID — open the plugin on
   [obsidian.md/plugins](https://obsidian.md/plugins) and check the URL, or look
   it up in
   [obsidian-releases/community-plugins.json](https://github.com/obsidianmd/obsidian-releases/blob/master/community-plugins.json).
2. Append the ID to `.obsidian/community-plugins.json`.
3. `make obsidian-plugins` — downloads it.
4. Reload Obsidian.

`install-plugins.sh` resolves each ID to its GitHub repo via the official
registry, then pulls `main.js`, `manifest.json`, and `styles.css` (if present)
from the latest release into `<vault>/.obsidian/plugins/<id>/`.

## Updating plugins

Re-run `make obsidian-plugins`. It always pulls the latest release tag and
overwrites in place.

## Keymap reference

The vimrc mirrors `nvim/lua/keymaps.lua` and the leader keys in
`nvim/lua/plugins/`. Leader is `<Space>`.

### Movement & editing

| Key       | Action                                |
| --------- | ------------------------------------- |
| `j` / `k` | Down/up by visual line (word-wrap)    |
| `<` / `>` | Indent in visual mode, keep selection |
| `J` / `K` | (Visual mode) move selection down/up  |
| `U`       | Redo (opposite of `u`)                |
| `<C-l>`   | (Insert mode) jump to end of line     |

### Tabs (nvim buffers ≈ Obsidian tabs)

| Key                | Action          |
| ------------------ | --------------- |
| `<S-l>`            | Next tab        |
| `<S-h>`            | Previous tab    |
| `<Space>bd`        | Close tab       |

### Panes (nvim windows ≈ Obsidian panes)

| Key       | Action            |
| --------- | ----------------- |
| `<C-h>`   | Focus left pane   |
| `<C-j>`   | Focus pane below  |
| `<C-k>`   | Focus pane above  |
| `<C-l>`   | Focus right pane  |

### Search / navigation

| Key          | Action                                  | nvim source            |
| ------------ | --------------------------------------- | ---------------------- |
| `<Space>p`   | Quick switcher (open file)              | snacks smart find      |
| `<Space>f`   | Global search across vault              | snacks grep            |
| `<Space>fr`  | Search & replace in current note        | grug-far               |
| `<Space>e`   | Reveal current file in file explorer    | snacks explorer focus  |
| `<Space>E`   | Toggle left sidebar (file explorer)     | snacks explorer toggle |
| `gr`         | Show backlinks for current note         | LSP references         |

### Not mapped

These exist in nvim but have no useful Obsidian analogue: LSP (`gd`, `gh`, `gi`,
`gs`, `gl`), diagnostics (`<leader>d`/`D`), git (`<leader>g*`), AI sidekick
(`<leader>a*`), yanky (`<leader>y*`), comment toggle (`<leader>c`), save
shortcuts (Obsidian autosaves).

## Notes

- The Vimrc Support plugin maps Obsidian commands via `exmap <name> obcommand
  <command-id>`. To find a command ID, run `:obcommand` in the Obsidian command
  line — it lists every available command.
- Leader is `<Space>`, unbound at the top of the vimrc and then used literally
  in every mapping. CodeMirror's vim doesn't support `:let mapleader`, so
  `<leader>` notation isn't available.
- If Obsidian shows "0 installed" community plugins after running
  `make obsidian-plugins`, restart the app — the plugin folder is only scanned
  on startup.
