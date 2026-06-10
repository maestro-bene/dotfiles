# NOTE: manage fish abbreviations
# https://fishshell.com/docs/current/cmds/abbr.html

abbr ar "asdf reshim"
abbr als "asdf list"
abbr ai "asdf install"
abbr apu "asdf plugin update --all"
abbr apl "asdf plugin list"
abbr apa "asdf plugin add"
abbr apr "asdf plugin remove"
abbr acv "nvim ~/.tool-versions"

abbr bi "brew install"
abbr bu "brew uninstall"

abbr c "clear"

abbr cm "chezmoi cd"

abbr dc "docker compose"
abbr dcu "docker compose up -d --build"
abbr dcd "docker compose down -v"
abbr dcr "docker compose restart"
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"
abbr dsp "docker system prune"

abbr e "exit"

abbr fi "fisher install"
abbr fr "fisher refresh"
abbr fu "fisher update"
abbr fl "fisher list"

abbr ga "git add ."
abbr gb "git branch -v"
abbr gc "git commit"
abbr gco "git checkout"
abbr gd "git branch --delete"
abbr gf "git fetch --all"
abbr gpom "git pull origin main"
abbr grao "git remote add origin"
abbr gs "git status"

abbr hd "history delete --exact --case-sensitive \'(history | fzf-tmux -p -m)\'"

abbr l "lsd  --group-dirs first"
abbr ls "lsd  --group-dirs first"
abbr ll "lsd  --group-dirs first -l"
abbr la "lsd --group-dirs first -A"
abbr lla "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"
abbr lg "lazygit"

abbr mci "mvn clean install"

abbr nb "npm run build"
abbr nd "npm run dev"
abbr ni "npm install"
abbr nt "npm run test"

abbr pwdc "pwd | pbcopy"

abbr rmr "rm -r"

abbr sf "source ~/.config/fish/config.fish"
abbr st "tmux source ~/.tmux.conf"

abbr chezmoid "cd ~/.config && nvim . ; cd -"
abbr bashc "cd ~ && nvim .bashrc ; cd -"
abbr nvimc  "cd ~/.config/nvim && nvim lua/maestro-bene/plugins ; cd -"
abbr v "nvim"
abbr vd     "nvim ."
abbr vimc   "cd ~/.vim && nvim ~/.vimrc ; cd -"
abbr vfzf   "nvim (fd --type f --hidden --follow --exclude .git | fzf)"
abbr vgrep  "nvim +Grep"

abbr ta "tmux a"
abbr tat "tmux attach -t"
abbr td "t .config"
abbr tk "tmux kill-server"
abbr tkt "tmux kill-session -t"
abbr tr "tldr --list | fzf --header 'tldr (tealdeer)' --reverse --preview 'tldr {1} --color=always' --preview-window=right,80% | xargs tldr"
abbr tls "tmux list-sessions"
abbr tlw "tmux list-windows"
abbr tn "tmux new -s (basename (pwd))"
#abbr tt "touch t && chmod +x t && echo -e '#!/usr/bin/env bash\n' > t && nvim t"

abbr x      "chmod +x (ls | fzf --header='chmod +x')"
abbr nx     "chmod -x (ls | fzf --header='chmod -x')"

abbr wgh    "wget --spider https://www.github.com"

abbr ze "chezmoi edit"
abbr fishc "chezmoi edit ~/.config/fish/"
abbr sshc "chezmoi edit ~/.ssh/config"
abbr rsshc "cd ~/.ssh && vim ~/.ssh/config.d"
abbr config "chezmoi edit ~/.config"
abbr tmuxc "chezmoi edit ~/.tmux.conf"
abbr bashc "chezmoi edit ~/.config/bash/.bashrc"
abbr gitc "chezmoi edit ~/.gitconfig"
abbr aiderc "chezmoi edit ~/.aider.conf.yml"
abbr zcd "chezmoi cd"
abbr zd "chezmoi diff"
abbr zs "chezmoi status"
abbr za "chezmoi apply"
