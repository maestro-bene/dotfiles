set -gx FZF_DEFAULT_OPTS "\
--reverse \
--border rounded \
--no-info \
--pointer=' ' \
--marker=' ' \
--ansi \
--color='16,bg+:-1,gutter:-1,prompt:5,pointer:5,marker:6,border:4,label:4,header:italic'"

set -gx FZF_TMUX_OPTS "-p 55%,60%"

set -gx FZF_CTRL_R_OPTS "--border-label=' history ' \
--prompt='  '"
