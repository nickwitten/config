" Source vimrc
map <leader>rc :source $MYVIMRC<CR>
" Indent based on filetype
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
" Scroll with and without cursor
nnoremap <c-j> j<c-e>
nnoremap <c-k> k<c-y>
"silent! unmap <C-E>
"silent! unmap <C-Y>
" Set tab switch and move to H and L
nnoremap H gT
nnoremap L gt
nnoremap <c-h> :tabm -1<CR>
nnoremap <c-l> :tabm +1<CR>
" Create a tab with <c-n>
nnoremap <c-n> :tabnew<CR>
" Switch to current files directory
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" Paste register 0
nnoremap P "0p
" Cut to register 0
nnoremap X "0x
xnoremap X "0x
" Open the current window in a new tab
nnoremap <c-w>z :tab sp<CR>
" Close the current window force
nnoremap <c-w>! :q!<CR>
" Show current file path
nnoremap <leader>p 1<c-g>


" Session mappings
function! SaveSession()
    if filereadable(".session.vim")
        call input('Overwrite Session?')
    endif
    let curr_tab = tabpagenr()
    tabdo NERDTreeClose
    mks! ./.session.vim
    execute "tabn ".curr_tab
    NERDTree
    let tab = 1
    while tab <= tabpagenr("$")
        if tab != curr_tab
            execute "tabn ".tab
            NERDTreeMirror
        endif
        let tab += 1
    endwhile
    execute "tabn ".curr_tab
endfunction
command! SaveSession call SaveSession()
nnoremap <leader>s :SaveSession <CR>

function! LoadSession()
    if filereadable(".session.vim")
        :autocmd! NTGroup
        source ./.session.vim
        tabn 1
        NERDTree
        let tabs_ct = tabpagenr("$")
        let tab = 2
        while tab <= tabs_ct
            execute "tabn ".tab
            NERDTreeMirror
            let tab += 1
        endwhile
        call NT()
    else
        echo "No session saved"
    endif
endfunction
command! LoadSession call LoadSession()
nnoremap <leader>l :LoadSession <CR>

" When leaving tab focus on second window
function! FocusWindow2()
    if (winnr('$') > 1 && winnr() == 1)
        2 wincmd w
    endif
endfunction
autocmd TabLeave * call FocusWindow2()

" Search mappings
function! s:ShowMaps()
    " save the current content of register a
    let old_reg = getreg("a")
    " save the type of the register as well
    let old_reg_type = getregtype("a")
    try
        " redirect output to register a
        redir @a                         
        " Get the list of all key mappings silently, satisfy "Press ENTER to continue"
        silent map | call feedkeys("\<CR>")    
        " end output redirection
        redir END                         
        " new buffer in vertical window
        vnew                             
        " put content of register
        put a                             
        " Sort on 4th character column which is the key(s)
        " This is linux specific (powershell would be sort {$_[3]} )
        " %!sort -k1.4,1.4
    " Execute even if exception is raised
    finally                             
    " restore register a
    call setreg("a", old_reg, old_reg_type)
    endtry
endfunction
" Enable :ShowMaps to call the function
com! ShowMaps call s:ShowMaps()     
" Map keys to call the function
nnoremap <leader>m :ShowMaps<CR>           

function! RC()
    tabnew
    e $MYVIMRC:
    vnew ~/config/.vimrc
endfunction
com! RC call RC()

function! Swaps()
    execute "vnew " . &directory
endfunction
com! Swaps call Swaps()


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
" Plug 'vim-syntastic/syntastic'

" Initialize plugin system
call plug#end()
" PlugInstall to install packages

" Gruvbox
set termguicolors
autocmd vimenter * ++nested colorscheme gruvbox
set background=dark

" Nerdtree
function! NT()
    augroup NTGroup
    " Open the existing NERDTree on each new tab.
    autocmd BufWinEnter * silent NERDTreeMirror
    " Start NERDTree when Vim is opened and leave the cursor in it.
    autocmd VimEnter * NERDTree
    " Close the tab if NERDTree is the only window remaining in it.
    autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    augroup END
endfunction
call NT()

"Winresizer
let g:winresizer_start_key = '<leader>w :WinResizerStartResize<CR>'
nnoremap <leader>w :WinResizerStartResize<CR>

" Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

