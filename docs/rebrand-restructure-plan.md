# Rebrand + Restructure Plan

## Goal
Turn this Trung-based Neovim config into your own repository by:
1. removing Trung branding/names,
2. splitting the config into smaller, maintainable modules,
3. keeping the current behavior working during the migration.

## Phase 1 — Rebrand everything
### Rename repo-facing text
- Update `README.md` title, intro, install steps, FAQ, and links.
- Rename `doc/trung.txt` to a project-specific help file.
- Replace any `trung` group names, comments, and user-facing messages.
- Update `.github` templates/workflows that mention Trung.
- Review `opencode.json` and any other metadata for old naming.

### Rename Lua namespaces
- Replace `require('trung...')` modules with the `trung` namespace.
- Rename augroups like:
  - `trung-autosave`
  - `trung-autoreload`
  - `trung-highlight-yank`
  - `trung-lsp-*`
- Remove Trung-specific comments from `init.lua`.

## Phase 2 — Split the config into modules
### Suggested folder structure
```text
lua/
  config/
    init.lua
    options.lua
    autocmds.lua
    keymaps.lua
    filetypes.lua
  plugins/
    init.lua
    coding.lua
    ui.lua
    git.lua
    lsp.lua
    test.lua
    terminal.lua
  utils/
    project_root.lua
    snacks_search.lua
```

### What goes where
- `config/init.lua` → loads all config modules in the right order
- `config/options.lua` → editor options, globals, GUI-specific settings
- `config/autocmds.lua` → autosave, autoreload, yank highlight, diff popup logic
- `config/keymaps.lua` → all non-plugin keymaps and leader mappings
- `config/filetypes.lua` → custom filetype detection and filetype registration
- `plugins/init.lua` → combines all plugin spec modules for lazy.nvim
- `plugins/coding.lua` → core editing + code-assist plugins like indenting, search, motions, UX helpers, autopairs, autotag, snippets, AI helpers
- `plugins/ui.lua` → UI plugins like which-key, snacks UI pieces, notifications, statusline, icons
- `plugins/git.lua` → git workflow plugins like gitsigns, git browse, blame, diff helpers
- `plugins/lsp.lua` → LSP, diagnostics, completion, formatting, and language server setup
- `plugins/test.lua` → testing tools, runners, adapters, and debugging helpers
- `plugins/terminal.lua` → terminal and shell workflow plugins
- `utils/*.lua` → helper functions shared across modules

## Phase 3 — Reduce `init.lua` to a bootstrap file
Keep `init.lua` small and readable:
- load core config modules
- install/initialize plugin manager
- load plugin specs
- avoid large inline config blocks

Target shape:
```lua
require('trung.config')
require('trung.plugins')
```

## Phase 4 — Refactor plugin setup
Break the current `lazy.setup(...)` list into grouped modules:
- coding/editing plugins
- UI/navigation plugins
- git plugins
- LSP/completion plugins
- testing/debugging plugins
- terminal/utility plugins

Each plugin file should export a small spec table, not a huge mixed config.

## Phase 5 — Clean up structure and naming
- Keep the `lua/trung/` namespace consistent across all modules.
- Rename documentation tags and help files.
- Standardize file names (`snake_case` or `kebab-case`, but be consistent).
- Remove dead comments and commented-out experimental blocks.

## Phase 6 — Verification
- Start Neovim and verify there are no missing `require()` paths.
- Run formatter/linter if configured.
- Confirm plugin loading, filetype detection, keymaps, autocmds, and LSP behavior.
- Search the repo for any old upstream-template references and ensure only intentional historical references remain.

## Proposed migration order
1. Add the new module structure.
2. Move `options.lua`, `autocmds.lua`, and keymaps into the new namespace.
3. Split plugin specs out of `init.lua`.
4. Rename all `trung` paths/requires.
5. Update docs and metadata.
6. Delete old files only after everything boots cleanly.

## Done criteria
- `rg -n "upstream template|old template"` returns no unwanted branding references.
- `init.lua` is short and only bootstraps modules.
- Core config is split into focused files.
- Repo reads like a personal Neovim configuration, not a fork template.
