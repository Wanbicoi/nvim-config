# nvim

My personal Neovim configuration.

## Requirements

- Neovim `0.12+` (built on stable/nightly)
- `git`, `make`, `unzip`, a C compiler
- `ripgrep`
- A clipboard tool (`xclip`/`xsel`/`win32yank`)
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)

## Install

```sh
git clone <this-repo> "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
```

Start Neovim and [lazy.nvim](https://github.com/folke/lazy.nvim) installs every plugin
on first run. `:Lazy` shows plugin status.

## Layout

```text
init.lua              -- bootstraps config + plugins
lua/config/           -- options, keymaps, autocmds, filetypes
lua/plugins/          -- lazy.nvim specs (one concern per file)
lua/integrations/     -- environment adapters (zellij, tmux, wezterm, neovide)
lua/utils/            -- shared helpers
after/queries/        -- treesitter query overrides
```

## Notes

- `lazy-lock.json` is tracked on purpose, so plugin versions stay reproducible.
- Multiplexer-specific behavior (zellij/tmux/wezterm) lives in `lua/integrations/`;
  everything else stays environment-agnostic.
