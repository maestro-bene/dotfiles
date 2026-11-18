# Dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/) for **macOS**, **Ubuntu/Debian**, and **WSL 2**.

- **Terminal:** Ghostty, Rex, or another terminal emulator
- **Multiplexer:** tmux or Rex
- **Shell:** Fish by default, with Bash available
- **Editors:** Neovim with Lazy, and Vim with vim-plug
- **Navigation:** Zoxide, Television, and Sesh/Sex
- **Coding agent:** [Pi](https://pi.dev/)

## 💻 Supported platforms

- macOS (Apple Silicon and Intel)
- Ubuntu and Debian
- WSL 2 on Ubuntu/Debian

On macOS, Homebrew installs Apple command-line tools if needed. On Linux, the bootstrap and installer use APT and Homebrew. `curl` must be available to start the bootstrap; install it first if it is missing.

## ⚙️ Profiles and secrets

The profile and multiplexer are independent choices. Defaults are `public` and `tmux`.

- **public:** does not use `pass`.
- **personal:** requires these `pass` entries, one per line:
  - `chezmoi/personal/git_user_name`
  - `chezmoi/personal/git_user_email`
  - `chezmoi/personal/git_signing_key`
- **work:** requires these `pass` entries, one per line:
  - `chezmoi/work/git_user_name`
  - `chezmoi/work/git_user_email`
  - `chezmoi/work/git_signing_key`
  - `chezmoi/work/gitlab_host_1`
  - `chezmoi/work/gitlab_1_proxy`
  - `chezmoi/work/ssh_include_path_1`
  - `chezmoi/work/ai_api_url`
  - `chezmoi/work/ai_api_key`

> [!IMPORTANT]
> Initialize `pass` with your GPG key once, then create only the entries required by your selected profile. The installer does not configure `pass` or prompt for secret values. Never put secret values in this repository.

For example, initialize `pass` with your GPG key ID, then run the relevant `pass insert` commands. Each command prompts securely for its value:

```sh
pass init YOUR_GPG_KEY_ID

# For the personal profile:
pass insert chezmoi/personal/git_user_name
pass insert chezmoi/personal/git_user_email
pass insert chezmoi/personal/git_signing_key

# For the work profile, use these instead of or in addition to the personal entries:
pass insert chezmoi/work/git_user_name
pass insert chezmoi/work/git_user_email
pass insert chezmoi/work/git_signing_key
pass insert chezmoi/work/gitlab_host_1
pass insert chezmoi/work/gitlab_1_proxy
pass insert chezmoi/work/ssh_include_path_1
pass insert chezmoi/work/ai_api_url
pass insert chezmoi/work/ai_api_key
```

## 🧰 Multiplexer environments

| Choice     | Installed automatically                                  | Manual setup                                         |
| ---------- | -------------------------------------------------------- | ---------------------------------------------------- |
| **Common** | `sesh`, core tools, Fish and its plugins                 | —                                                    |
| **tmux**   | tmux, workmux, Tpack; the installer runs `tpack install` | —                                                    |
| **Rex**    | Workrex; `mise install` installs `sex` for this backend  | Install Rex, start it, and enable **Remote Control** |

The profile (`public`, `personal`, or `work`) does not affect which tools are installed; the multiplexer choice does. `sesh` is installed for every environment. `sex` is installed only for Rex.

> [!NOTE]
> Rex itself is not installed automatically. Follow the [official installation instructions](https://www.superlogical.com/rex/docs/installation). On Linux, also see [Rex's Linux instructions](https://www.superlogical.com/rex/docs/linux/installation); the Linux server is still under test.

Tpack loads tmux plugins through `run 'tpack init'`; update them later with `tpack update`. Tpack accepts TPM-style plugin declarations but uses its own plugin directories. Do not run TPM alongside Tpack against the same directory. Ghostty is optional and is not installed by the main installer.

## 🚀 Installation

> [!WARNING]
> The command below downloads and executes scripts from this repository. Review them first if you do not already trust the source.

After configuring `pass` as needed for your selected profile, run the bootstrap in a terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/maestro-bene/dotfiles/main/dot_local/bin/executable_bootstrap | bash
```

The bootstrap installs Homebrew and Chezmoi, initializes this repository, and starts the dotfiles installer. The installer asks you to choose a profile (`public`, `personal`, or `work`) and a multiplexer (`tmux` or `rex`), installs their dependencies, and asks for confirmation before applying the configuration. Your choices are saved in `~/.config/chezmoi/chezmoi.toml`.

After applying the dotfiles, the installer runs `mise install`, `tv update-channels`, and `fisher update`. It also installs tmux plugins with `tpack install` when tmux is selected. **You do not need to run the installer again after the initial setup.**

## 📝 Post-installation

### Local Neovim environment variables

Before the first `nvim` launch, create `~/.config/fish/secrets.fish` and set your local paths:

```fish
set -gx OBSIDIAN_VAULT path_to_obsidian_vault
set -gx TREE_SITTER_LOGSTASH_PATH path_to_logstash_parser_repo
```

Replace the examples with your actual paths. `TREE_SITTER_LOGSTASH_PATH` must point to a clone of [`tree-sitter-logstash.nvim`](https://github.com/maestro-bene/tree-sitter-logstash.nvim). Fish loads this file automatically; launch Neovim from Fish so it inherits these variables.

### Vim plugins

Vim reads `~/.config/vim/vimrc` and loads its plugins with [vim-plug](https://github.com/junegunn/vim-plug). Only the manifest is versioned:

| Path | Managed by chezmoi |
| ---- | ------------------ |
| `~/.config/vim/vimrc`, `plugins.vim`, `remaps.vim`, `indent/`, `syntax/` | Yes |
| `~/.config/vim/bundle/` (plugin checkouts), `autoload/plug.vim` | No, generated |

Edit `~/.config/vim/plugins.vim` and run `chezmoi apply`: a chezmoi script re-runs `vim-plugins install` whenever the manifest changes, so plugins are installed on a new machine without any extra step. The helper is also usable directly:

| Command              | Effect                                                                  |
| -------------------- | ----------------------------------------------------------------------- |
| `vim-plugins`        | Install missing plugins (same as `vim-plugins install`)                   |
| `vim-plugins update` | Fetch the latest commit of every plugin and upgrade vim-plug              |
| `vim-plugins clean`  | Remove plugin directories that are no longer in the manifest              |
| `vim-plugins status` | Show the manifest, the manager, and the installed plugin directories      |

Vim requires `git`, and `curl` on the very first run to download vim-plug. A healthy start prints no error; check with `:messages`. If a leftover Pathogen layout is found (`~/.config/vim/autoload/pathogen.vim`), the first run moves `bundle/`, `colors/`, and Pathogen itself to `~/.local/state/vim-pathogen-backup-<timestamp>/`; delete that directory once Vim looks right.

The main installer installs full `vim` from APT on Linux. macOS relies on the system Vim; install Homebrew's `vim` if yours ignores `~/.config/vim/vimrc`.

### Synchronized SSH hosts

`~/.local/bin/ssh-sync-config` runs as an OpenSSH `LocalCommand` and pushes, for the matching account only, `~/.bashrc`, `~/.profile`, `~/.config/bash`, and the whole `~/.config/vim` tree. The plugins are therefore copied to the remote host, which is what makes offline hosts usable, but the per-plugin git metadata is excluded from the transfer. Keep this in mind:

- Update plugins **locally** (`vim-plugins update`); the next SSH connection propagates them.
- The remote copy has no `.git`, so `vim-plugins update` must not be run on a synchronized host.
- Since the whole tree is copied, files removed from your local `~/.config/vim` disappear remotely too (previous versions are kept under `~/.local/state/chezmoi-ssh-backups/`).

### Pi and Neovim

- In Pi, configure a provider with `/login`, then choose a model with `/model`. This repository does not provide an account or credentials.
- Neovim plugins install on the first `nvim` launch. Wait for installation to finish, then restart Neovim.

## 🔄 Updates

Chezmoi manages the dotfiles. After updating the source repository, review changes with `chezmoi diff`, then apply them with `chezmoi apply`. Update tmux plugins with `tpack update`, Vim plugins with `vim-plugins update`, and Fish plugins with `fisher update`.
