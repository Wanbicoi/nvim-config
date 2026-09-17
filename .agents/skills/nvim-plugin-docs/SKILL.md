---
name: nvim-plugin-docs
description: Look up documentation and source code for installed Neovim plugins managed by lazy.nvim. Use this skill when configuring a plugin and you need to check its options, API, keymaps, or implementation details. Covers plugins from lazy.nvim, snacks.nvim, mini.nvim, and Neovim built-in runtime.
---

# Neovim Plugin Docs & Code Lookup

Use this skill whenever you need to check plugin documentation or source code to correctly configure a plugin in this Neovim config.

## Key Paths

| Source | Path |
|--------|------|
| Neovim built-in runtime docs | `/usr/share/nvim/runtime/doc/` |
| lazy.nvim installed plugins root | `/home/troy/.local/share/nvim/lazy/` |
| Plugin help docs | `/home/troy/.local/share/nvim/lazy/<plugin-name>/doc/` |
| Plugin Lua source | `/home/troy/.local/share/nvim/lazy/<plugin-name>/lua/` |

## How to Find a Plugin

### 1. List all installed plugins
```bash
ls /home/troy/.local/share/nvim/lazy/
```

### 2. Browse a specific plugin docs
```bash
ls /home/troy/.local/share/nvim/lazy/<plugin-name>/doc/
```

### 3. Read a doc file
```bash
cat /home/troy/.local/share/nvim/lazy/<plugin-name>/doc/<docfile>.txt
```

### 4. Search plugin source for a config option or function
```bash
grep -rn "option_name" /home/troy/.local/share/nvim/lazy/<plugin-name>/lua/
```

## Important Plugins in This Config

This config relies heavily on the following plugins — check their docs/source first:

### lazy.nvim
- Docs: `/home/troy/.local/share/nvim/lazy/lazy.nvim/doc/`
- Source: `/home/troy/.local/share/nvim/lazy/lazy.nvim/lua/lazy/`

### snacks.nvim
- Docs: `/home/troy/.local/share/nvim/lazy/snacks.nvim/doc/`
- Source: `/home/troy/.local/share/nvim/lazy/snacks.nvim/lua/snacks/`
- Each snack module lives at `lua/snacks/<module>.lua`

### mini.nvim
- Docs: `/home/troy/.local/share/nvim/lazy/mini.nvim/doc/`
- Source: `/home/troy/.local/share/nvim/lazy/mini.nvim/lua/mini/`
- Each mini module lives at `lua/mini/<module>.lua` (e.g. mini.files, mini.pick)

## Workflow When Configuring a Plugin

1. **Identify the plugin name** — check `lazy-lock.json` or the plugin spec in `lua/plugins/`.

2. **Check if it has docs**:
   ```bash
   ls /home/troy/.local/share/nvim/lazy/<plugin-name>/doc/
   ```

3. **Read the vimdoc** — `.txt` vimdoc files contain structured help including options tables, API refs, and examples.

4. **Search the source** when docs are incomplete or you need exact function signatures:
   ```bash
   grep -rn "setup\|config\|opts\|M\." /home/troy/.local/share/nvim/lazy/<plugin-name>/lua/
   ```

5. **Check existing config usage**:
   ```bash
   grep -r "<plugin-name>" /mnt/c/Users/TroyHoang/AppData/Local/nvim/lua/
   ```

## Tips

- **vimdoc tags**: Tags like `*plugin-option-name*` are help tags — grep with `grep -n '\*' doc/file.txt` to find option names quickly.
- **snacks modules**: Each snack (`snacks.picker`, `snacks.dashboard`, etc.) is self-contained — read `lua/snacks/<module>.lua` for full option definitions.
- **mini modules**: Each module has a `setup()` accepting an opts table — options are documented inline in the source file.
- **Default values**: Look for `M.config` or `default_config` tables in plugin source to see all available options and their defaults.
- **Neovim built-ins**: For LSP, treesitter, diagnostic, or other built-in docs use `/usr/share/nvim/runtime/doc/`.
