# Profils et environnements

Le profil (`public`, `personal`, `work`) et l’environnement (`tmux`, `rex`) sont deux choix indépendants. Les valeurs par défaut sont `public` + `tmux`. L’installateur installe les outils communs et uniquement ceux du backend choisi. Ghostty est optionnel et n’est jamais installé par l’installateur principal.

## Profils et `pass`

Le profil `public` n’utilise pas `pass`. Pour `personal` ou `work`, configurez `pass` vous-même et créez les entrées requises avant l’application; l’installateur ne configure pas le gestionnaire de mots de passe et ne demande jamais les secrets.

- `personal` : `chezmoi/personal/git_user_name`, `chezmoi/personal/git_user_email`, `chezmoi/personal/git_signing_key`.
- `work` : `chezmoi/work/git_user_name`, `chezmoi/work/git_user_email`, `chezmoi/work/git_signing_key`, `chezmoi/work/gitlab_host_1`, `chezmoi/work/gitlab_1_proxy`, `chezmoi/work/ssh_include_path_1`, `chezmoi/work/ai_api_url`, `chezmoi/work/ai_api_key`.

Ne mettez pas les valeurs secrètes dans le dépôt. Les noms ci-dessus sont les chemins des entrées, pas leur contenu.

## tmux + workmux

Le choix `tmux` installe tmux et workmux. Installez [TPM](https://github.com/tmux-plugins/tpm#installation) une fois, puis démarrez tmux et faites `Préfixe`, `I` pour installer les plugins. Les fonctions optionnelles d’icônes et de presse-papiers dépendent du terminal et du système.

## Rex + workrex

Le choix `rex` installe Workrex, mais pas Rex. Installez Rex séparément selon les [instructions officielles](https://www.superlogical.com/rex/docs/installation), démarrez-le, puis activez **Remote Control** dans ses réglages pour les changements de session. Sur Linux, Rex est un serveur en test; consultez ses [instructions Linux](https://www.superlogical.com/rex/docs/linux/installation). Le manifeste Mise ajoute `sex` à cet environnement.
