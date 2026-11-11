# Neovim Configuration

This configuration is managed as part of the dotfiles repository with chezmoi. The canonical source lives at `dot_config/nvim`; the separate legacy repository is retained unchanged for now.

## Requirements

- Neovim (current stable release or newer), Git, and `ripgrep`.
- A C compiler, `make`, CMake, and Rust/Cargo for native plugin builds. The portable setup provides the macOS Xcode command line tools or the Ubuntu/Debian `build-essential`/CMake packages.
- Node.js and npm for some language tooling and plugins; the mise manifest provides Node.js.
- Python 3 on `PATH` for the optional Python provider; Python provider packages can be installed with `python3 -m pip install --user pynvim` if Python plugins need it.
- Some filetype-specific servers and formatters are installed separately by Mason and may require additional system libraries or language toolchains.
- A Nerd Font is recommended for icons.
- A clipboard provider is recommended (e.g. `pbcopy` on macOS or `wl-clipboard` on Wayland).

The dotfiles mise manifest (`~/.config/mise/config.toml`) declares shared language/tool versions. Mason also installs configured LSP servers and formatters when Neovim starts. Some language-specific tools are optional and only needed for the corresponding filetypes.

## First launch

1. Install the dotfiles requirements and apply chezmoi, following the root README.
2. Before starting Neovim, create `~/.config/fish/secrets.fish` and set the local paths used by the Obsidian and Logstash parser integrations:

   ```fish
   set -gx OBSIDIAN_VAULT path_to_obsidian_vault
   set -gx TREE_SITTER_LOGSTASH_PATH path_to_logstash_parser_repo
   ```

   Replace these placeholders with your actual paths. `TREE_SITTER_LOGSTASH_PATH` should point to a clone of [`tree-sitter-logstash.nvim`](https://github.com/maestro-bene/tree-sitter-logstash.nvim). Fish loads this file automatically; launch Neovim from Fish for these variables to be available.
3. Start `nvim`. `lazy.nvim` bootstraps itself and installs the pinned plugins from `lazy-lock.json`.
4. Wait for plugin installation/builds to finish, then restart Neovim. Treesitter parsers and Mason tools may install on first launch.

To review plugins, use `:Lazy`. To review LSP servers and tools, use `:Mason`.

### Markdown preview

The `markdown-preview.nvim` plugin needs its Node.js dependencies. Lazy.nvim runs `npm install` in the plugin's `app` directory as its build step when installing the plugin. If that build fails or needs to be retried, run:

```sh
cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && npm install
```

The plugin's dependency tree currently reports known npm vulnerabilities. `npm audit` only reports them; **do not run `npm audit fix` or `npm audit fix --force` in this plugin directory**: changing the plugin's transitive dependencies can break its preview server. The Neovim config keeps the preview server bound to `127.0.0.1` rather than exposing it to the network.

## Optional settings

- Set `OBSIDIAN_VAULT` to the path of an existing Obsidian vault. Without it, the config uses a harmless default under Neovim's data directory.
- If a language is not part of your workflow, its Mason/LSP tools can be skipped; missing tools affect that language's integrations rather than basic editing.

## Platform notes

The core configuration targets macOS and Ubuntu/Debian, including WSL. WSL-specific clipboard integration and GUI-specific behavior depend on your terminal/WSL setup. Arch Linux/Omarchy is not yet in the supported install path.
