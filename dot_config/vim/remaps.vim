" Navigation facile entre les fenêtres avec Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" :Files pour chercher un fichier, :Buffers pour changer de buffer, etc.
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>l :Lines<CR>

" Undo tree
nnoremap <leader>u :UndotreeToggle<CR>

" vim-abolish : cycler booléens
" true <-> false, yes <-> no, on <-> off, etc.

" Incrémenter/décrémenter un nombre (natif Vim)
" <C-a> : incrémente le nombre sous le curseur
" <C-x> : décrémente
nnoremap <leader>ic <C-a>
nnoremap <leader>dc <C-x>

" Write and escape
nnoremap <leader><leader> :w<CR>
nnoremap <leader>q :q<CR>
