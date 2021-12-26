set mouse=a
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
nnoremap <c-w>C :q!<CR>
nnoremap <c-w>! :q!<CR>
" Show current file path
nnoremap <leader>p 1<c-g>
" Terminal mappings
nnoremap <leader>t :term<CR>
nnoremap <leader>T :tab term<CR>
tnoremap <c-w>[ <c-w>N
tnoremap <c-w>c <c-w>N



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
set sessionoptions+=globals

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
        tabn 1
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


function! RC()
    tabnew
    e $MYVIMRC
    vnew ~/config/.vimrc
endfunction
com! RC call RC()

function! Swaps()
    execute "vnew " . &directory
endfunction
com! Swaps call Swaps()


function! Redir(cmd)
    tabnew
    redir @">| silent execute(a:cmd) | put "
endfunction
com! -nargs=1 Redir call Redir(<f-args>)


function! Run()
    term
    call term_sendkeys("", g:RunCMD)
endfunction
nnoremap <leader>y :call Run()<CR><CR>
com! -nargs=1 Run let g:RunCMD = <f-args> | echo "LEADER-Y to Run"

function! MoveBuff(direction)
    let buffn = bufnr("%")
    close!
    if a:direction == "r"
        silent! tabn +1
    else
        if a:direction == "l"
            silent! tabn -1
        else
            echo "Specify Direction"
            return
        endif
    endif
    execute "sbuff " . buffn
endfunction
com! -nargs=1 MoveBuff call MoveBuff(<f-args>)
nnoremap <leader><c-l> :MoveBuff r<CR>
nnoremap <leader><c-h> :MoveBuff l<CR>


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
Plug 'davidhalter/jedi-vim'
Plug 'vim-syntastic/syntastic'

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
let NERDTreeShowBookmarks = 1

"Winresizer
let g:winresizer_start_key = '<leader>w :WinResizerStartResize<CR>'
nnoremap <leader>w :WinResizerStartResize<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Jedi-Vim
let g:jedi#goto_stubs_command = "<F1>"
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 2  " in cmdline
let g:jedi#force_py_version = 3.8
let g:jedi#use_splits_not_buffers = "winwidth"
let g:jedi#smart_auto_mappings = 1
if len(globpath('.', 'venv', 1, 1)) > 0
    let g:jedi#environment_path = "venv"
else
    let g:jedi#environment_path = ""
endif
