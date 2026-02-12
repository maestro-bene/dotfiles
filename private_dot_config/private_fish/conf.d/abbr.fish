# NOTE: manage fish abbreviations
# https://fishshell.com/docs/current/cmds/abbr.html

abbr ar "asdf reshim"
abbr als "asdf list"
abbr ai "asdf install"
abbr apu "asdf plugin update --all"
abbr apl "asdf plugin list"
abbr apa "asdf plugin add"
abbr apr "asdf plugin remove"

abbr bi "brew install"
abbr bu "brew uninstall"

abbr c "clear"
abbr cx "chmod +x"

abbr dc "docker compose"
abbr dcd "docker compose down"
abbr dcdv "docker compose down -v"
abbr dcr "docker compose restart"
abbr dcu "docker compose up -d --build"
abbr dps "docker ps --format 'table {{.Names}}\t{{.Status}}'"
abbr dsp "docker system prune"

abbr e exit

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

abbr l "lsd  --group-dirs first -A"
abbr ll "lsd  --group-dirs first -Al"
abbr lt "lsd  --group-dirs last -A --tree"

abbr mci "mvn clean install"

abbr nb "npm run build"
abbr nd "npm run dev"
abbr ni "npm install"
abbr nt "npm run test"

abbr pwdc "pwd | pbcopy"

abbr rmr "rm -rf"

abbr sf "source ~/.config/fish/config.fish"

abbr vd "nvim ."
abbr vfzf "nvim (fd --type f --hidden --follow --exclude .git | fzf)"
abbr fishc "nvim ~/.config/fish/config.fish"
abbr nvimc "nvim ~/.config/nvim/"
abbr vimc "nvim ~/.config/nvim/"
abbr config "nvim ~/.config/"

abbr sshc "vim ~/.ssh/config"

abbr x "chmod +x (ls | fzf --header='chmod +x')"
abbr nx "chmod -x (ls | fzf --header='chmod -x')"

abbr za "zoxide add"
abbr ze "zoxide edit"

abbr :Grep "nvim +Grep"
