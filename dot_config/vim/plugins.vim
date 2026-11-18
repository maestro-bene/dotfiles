" Vim plugin manifest, managed by chezmoi.
"
" This is the only file to edit: the plugin directories themselves live in
" ~/.config/vim/bundle and are never versioned. After changing this file, run
" `vim-plugins install` (or `chezmoi apply`, which does it for you).
" Manager: vim-plug, bootstrapped by ~/.local/bin/vim-plugins.
call plug#begin(expand('~/.config/vim/bundle'))

" Appearance
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy finding (:Files, :Buffers, :Lines). The fzf binary comes from Homebrew.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Editing
Plug 'AndrewRadev/switch.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Navigation
Plug 'tpope/vim-vinegar'

" Git and history
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'

" Syntax checking
Plug 'vim-syntastic/syntastic'

" Misc
Plug 'vim-scripts/sudo.vim'

call plug#end()
