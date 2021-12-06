colorscheme desert
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Ignore case in search
set ignorecase
" Set vim swap, undo, and backup directory
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
" Set tab switch and move to H and L
nnoremap H gT
nnoremap L gt
nnoremap <c-h> :tabm -1<enter>
nnoremap <c-l> :tabm +1<enter>
" Switch to current files directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" Paste register 0
nnoremap P "0p
" Cut to register 0
nnoremap X "0x
