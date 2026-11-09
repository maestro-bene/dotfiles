# Ubuntu, Debian et WSL

La cible Linux documentée est Ubuntu/Debian, y compris WSL 2 (WSL 1 n’est pas pris en charge). Utilisez les [étapes d’installation](../README.md#installation). L’installateur principal installe les prérequis APT, installe Homebrew si nécessaire et configure son environnement pour poursuivre; il n’y a pas de pause Homebrew à effectuer ni de deuxième script APT à lancer.

Homebrew fournit les outils utilisateur; APT installe les prérequis de compilation et de bootstrap. Le presse-papiers sous Linux peut nécessiter un outil Wayland/X11 installé par l’utilisateur.

Rex pour Linux est un serveur actuellement en test; son installation n’est pas automatisée. Voir [Rex + workrex](backends.md#rex--workrex) et les [instructions officielles Linux de Rex](https://www.superlogical.com/rex/docs/linux/installation).
