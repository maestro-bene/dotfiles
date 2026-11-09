# Dotfiles

Configuration macOS et Ubuntu/Debian (dont WSL 2), gérée avec [chezmoi](https://www.chezmoi.io/). Le dépôt configure le shell (Bash/Fish), Neovim, Television, Pi agent et un environnement au choix (tmux ou Rex).

## Installation

1. Sur macOS, installez les outils de ligne de commande Apple si nécessaire (`xcode-select --install`). Sur Linux, utilisez Ubuntu/Debian avec `sudo` et `apt`.
2. Pour les profils `personal` ou `work`, préparez d’abord `pass` et les entrées requises dans [Profils et secrets](docs/backends.md). Le profil `public` n’en a pas besoin.
3. Depuis le clone, lancez une seule fois, dans un terminal interactif :

   ```sh
   bash dot_local/bin/executable_install-config
   ```

   Choisissez le profil (`public`, `personal`, `work`) et l’environnement (`tmux` ou `rex`), vérifiez les changements proposés, puis confirmez leur application.

L’installateur installe Homebrew si nécessaire, les paquets communs du `Brewfile` et ceux du backend choisi; sur Linux, il installe aussi les quelques prérequis APT. Il initialise Chezmoi puis propose d’appliquer les fichiers de configuration. **Le script n’est pas lancé une deuxième fois automatiquement.** Lors de l’application, Chezmoi en installe simplement une copie sous `~/.local/bin/install-config`, pour refaire volontairement ce parcours plus tard; ce second lancement n’est pas une étape de l’installation.

Le préfixe `executable_` est une convention de nommage Chezmoi : il transforme le fichier source en commande exécutable `~/.local/bin/install-config`. Le script existe donc à deux emplacements selon le moment où on l’utilise, mais il n’est exécuté qu’une fois pendant l’installation initiale.

Le choix du profil et du backend ne vaut que pour cette exécution. Pour que les commandes Chezmoi suivantes gardent le même choix, lancez `chezmoi edit-config` et définissez, par exemple :

```toml
[data]
    profile = "personal"
    multiplexer = "rex"
```

## Après l’application

Effectuez seulement les étapes correspondant à votre usage :

- **Outils de développement :** `mise install` installe les versions déclarées par la configuration (Go, Node.js, Python et Rust). Mise les rend disponibles dans l’environnement du shell.
- **Fish :** les dotfiles configurent Fish (variables et intégrations), mais ne changent pas votre shell de connexion. Si vous voulez utiliser Fish par défaut, changez-le vous-même (`chsh -s "$(command -v fish)"`). Depuis Fish, lancez `fisher update` pour synchroniser les plugins déclarés dans `fish_plugins`.
- **Television :** `tv update-channels` actualise les channels fournis par Television. Les channels personnalisés de ce dépôt sont installés avec les dotfiles.
- **Pi agent :** l’installateur installe Pi et les extensions du manifeste. Au premier lancement, utilisez `/login` pour configurer un fournisseur, puis `/model` pour choisir un modèle. Le dépôt ne fournit ni compte ni identifiants.
- **Neovim :** lancez `nvim`; ses plugins s’installent au premier démarrage. Si l’aperçu Markdown ne se construit pas, les [notes Neovim](dot_config/nvim/README.md#markdown-preview) donnent la commande de réparation.
- **tmux uniquement :** installez TPM une fois, puis dans tmux utilisez le préfixe suivi de `I` pour installer les plugins. Détails dans [le guide des environnements](docs/backends.md#tmux--workmux).
- **Rex uniquement :** installez Rex séparément, démarrez/configurez son serveur et activez Remote Control. Voir [le guide des environnements](docs/backends.md#rex--workrex).

Les guides complémentaires détaillent les différences de plateforme et les profils : [macOS](docs/macos.md), [Linux](docs/debian-based.md), [profils et environnements](docs/backends.md).

## Ce que l’installation ne fait pas

Elle n’installe pas Ghostty, Rex, les plugins TPM ou les plugins Fish; les étapes utiles sont listées ci-dessus. Ghostty peut être installé séparément avec `brew install --cask ghostty`.
