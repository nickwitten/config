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
silent call mkdir ($HOME.'/.vim/backup', 'p')
set backupdir=~/.vim/backup//
silent call mkdir ($HOME.'/.vim/undo', 'p')
set undodir=~/.vim/undo//
silent call mkdir ($HOME.'/.vim/swap', 'p')
set directory=~/.vim/swap//
" Set tab switch and move to H and L
nnoremap H gT
nnoremap L gt
nnoremap <c-h> :tabm -1<enter>
nnoremap <c-l> :tabm +1<enter>
" Create a tab with <c-n>
nnoremap <c-n> :tabnew <enter>
" Switch to current files directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" Paste register 0
nnoremap P "0p
" Cut to register 0
nnoremap X "0x
xnoremap X "0x

function SaveSessionQuit()
    tabdo NERDTreeClose
    mks! ./.session.vim
    qa
endfunction
command SaveSessionQuit call SaveSessionQuit()
nnoremap <leader>s :SaveSessionQuit <enter>

function LoadSession()
    if filereadable(".session.vim")
        tabdo NERDTreeClose
        source ./.session.vim
        tabn 1
        NERDTree
        if (tabpagenr('$') != 1)
            NERDTreeClose
        endif
    else
        echo "No session saved"
    endif
endfunction
command LoadSession call LoadSession()
nnoremap <leader>l :LoadSession <enter>


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'simeji/winresizer'
Plug 'vim-syntastic/syntastic'

" Initialize plugin system
call plug#end()
" PlugInstall to install packages

" Gruvbox
set termguicolors
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Nerdtree
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror
" Start NERDTree when Vim is opened and leave the cursor in it.
autocmd VimEnter * NERDTree
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
