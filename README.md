# Dotfiles

Personal configuration managed with [chezmoi](https://www.chezmoi.io/) for **macOS**, **Ubuntu/Debian**, and **WSL 2**.

- **Terminal:** Ghostty, Rex, or another terminal emulator
- **Multiplexer:** tmux or Rex
- **Shell:** Fish by default, with Bash available
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

### Pi and Neovim

- In Pi, configure a provider with `/login`, then choose a model with `/model`. This repository does not provide an account or credentials.
- Neovim plugins install on the first `nvim` launch. Wait for installation to finish, then restart Neovim.

## 🔄 Updates

Chezmoi manages the dotfiles. After updating the source repository, review changes with `chezmoi diff`, then apply them with `chezmoi apply`. Update tmux plugins with `tpack update`.
