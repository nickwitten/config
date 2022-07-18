set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
set hidden
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set shiftround
set smarttab
set expandtab
set ignorecase
set smartcase
set number
set noerrorbells
set ruler
set list
set listchars=tab:►\ ,trail:•
set scrolloff=8
set splitright
" turn hybrid line numbers on
set number relativenumber
set nu rnu
set hls

"set clipboard^=unnamed,unnamedplus
"set clipboard=unnamed
silent! call mkdir ($HOME.'/.vim/backup', 'p')
set backupdir=~/.vim/backup//
silent! call mkdir ($HOME.'/.vim/undo', 'p')
set undodir=~/.vim/undo//
silent! call mkdir ($HOME.'/.vim/swap', 'p')
set directory=~/.vim/swap//

let mapleader = " "
map <leader>rc :source $MYVIMRC<CR>
" Scroll with and without cursor
nnoremap <c-j> j<c-e>
nnoremap <c-k> k<c-y>
" Set tab switch and move to H and L
nnoremap H gT
nnoremap L gt
nnoremap <c-h> :tabm -1<CR>
nnoremap <c-l> :tabm +1<CR>
" Create a tab with <c-n>
nnoremap <c-n> :tabnew<CR>
nnoremap <c-x> :tabclose<CR>
" Switch to current files directory
" nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>
" Paste register 0
nnoremap P "0p
" Cut to register 0
nnoremap X "0x
xnoremap X "0x
" Open the current window in a new tab
nmap <c-w>z <c-w>v<c-w>L<c-w>T
nnoremap <c-s> :new<CR>
" Close the current window force
nnoremap <c-w>C :q!<CR>
nnoremap <c-w>! :q!<CR>
" Terminal mappings
nnoremap <leader>t :vertical term<CR>
nnoremap <leader>T :tab term<CR>
tnoremap <c-w>[ <c-w>N:set norelativenumber<CR>:set nonumber<CR>
tnoremap <c-w>c <c-w>N
" Search
nnoremap * *N
vnoremap * "ay :exe 'Search '.@a<CR> NN
vnoremap c* "ay :exe 'Search '.@a<CR> NN cgn
nnoremap # :noh<CR>
nnoremap c* *N cgn
com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\/')| normal! n
" Folds
set foldmethod=indent
nnoremap <leader>f za
nnoremap <leader>F zO
nnoremap <leader>af zM
nnoremap <leader>uf zR
" Paste mode
nnoremap <leader>v :set paste<CR>"*p:set nopaste<CR>
" Redraw
nnoremap <leader>! :redraw!<CR>
" Visual mode tab
vnoremap < <gv
vnoremap > >gv
" Edit path under cursor
map gf :edit <cfile><CR>


" Macro over visual selection
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

" Wipeout inactive buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

" Save current working directory
" CD to either path under cursor or to saved working directory
function! SaveCWD()
    let g:SavedCWD=getcwd()
endfunction

function! ChangeCWD()
    let cursorpath = expand("<cfile>")
    let fullpath = expand(cursorpath)
    if isdirectory(fullpath)
        execute("cd " . fullpath)
        echo fullpath
    else
        if exists("g:SavedCWD")
            execute("cd " . g:SavedCWD)
            echo g:SavedCWD
        endif
    endif
endfunction
" Switch to current path under cursor
" nnoremap <leader>cd :cd <cfile><CR>:echo expand("<cfile>")<CR>
nnoremap <leader>cd :call ChangeCWD()<CR>


" Session mappings
function! SaveSession()
    let g:SavedCWD=getcwd()
    if filereadable(".session.vim")
        call input('Overwrite Session?')
    endif
    let curr_tab = tabpagenr()
    tabdo NERDTreeClose
    mks! ./.session.vim
    execute "tabn ".curr_tab
endfunction
command! SaveSession call SaveSession()
nnoremap <leader>s :SaveSession <CR>
set sessionoptions+=globals

function! LoadSession()
    if filereadable(".session.vim")
        source ./.session.vim
    else
        echo "No session saved"
    endif
endfunction
command! LoadSession call LoadSession()
nnoremap <leader>l :LoadSession <CR>

" " When leaving tab focus on second window
" function! FocusWindow2()
"     if (winnr('$') > 1 && winnr() == 1)
"         2 wincmd w
"     endif
" endfunction
" autocmd TabLeave * call FocusWindow2()

function! OpenTermInPlace()
    let curr_buf = bufnr("")
    term
    execute "bd ".curr_buf
endfunction
nnoremap <leader>i :call OpenTermInPlace()<CR>

function! RC()
    tabnew
    e ~/config/.bashrc
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
    if exists("g:RunCMD")
        vertical term
        call term_sendkeys("", g:RunCMD)
    else
        echo "RunCMD Not Defined"
    endif
endfunction
nnoremap <leader>y :call Run()<CR><CR>
com! -nargs=1 Run let g:RunCMD = <f-args> | echo "LEADER-Y to Run"

function! RemoteTerm()
    if exists("g:RemoteCMD")
        vertical term
        call term_sendkeys("", "ssh " . g:RemoteCMD)
    else
        echo "RemoteCMD Not Defined"
    endif
endfunction
nnoremap <leader>rt :call RemoteTerm()<CR><CR>
com! -nargs=1 Remote let g:RemoteCMD = <f-args> | echo "LEADER-RT to Open Terminal"

function! Serial()
    if exists("g:SerialArgs")
        vertical term
        call term_sendkeys("", "python -m serial.tools.miniterm " . g:SerialArgs)
    else
        echo "SerialArgs Not Defined"
    endif
endfunction
nnoremap <leader>p :call Serial()<CR><CR>
com! -nargs=1 Serial let g:SerialArgs = <f-args> | echo "LEADER-P to Open Serial Port"

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
Plug 'gcmt/taboo.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" PLUGIN: Plug 'vim-syntastic/syntastic'

" Initialize plugin system
call plug#end()
" PlugInstall to install packages

" PLUGIN: Gruvbox
let g:gruvbox_contrast_dark = 'hard'
set termguicolors
" Set gruvbox colors in the terminal too
"black
"dark red
"dark green
"brown
"dark blue
"dark magenta
"dark cyan
"light grey
"dark grey
"red
"green
"yellow
"blue
"magenta
"cyan
"white
let g:terminal_ansi_colors = ['#282828', '#FB4934', '#8EC07C', '#FABD2F', '#83A598', '#9c1dcf', '#8EC07C', '#928374', '#282828', '#FB4934', '#B8BB26', '#FABD2F', '#83A598', '#D3869B', '#8EC07C', '#A89984']
" let g:terminal_ansi_colors = ['#282828', '#FB4934', '#8EC07C', '#FABD2F', '#458588', '#B16286', '#8EC07C', '#928374', '#282828', '#FB4934', '#B8BB26', '#FABD2F', '#83A598', '#9c1dcf', '#8EC07C', '#A89984']
" autocmd vimenter * ++nested colorscheme gruvbox
autocmd vimenter * nested colorscheme gruvbox
set background=dark
set cursorline
autocmd! ColorScheme * hi clear CursorLine | hi Search cterm=NONE guifg=Purple guibg=NONE | hi IncSearch cterm=NONE guifg=Purple guibg=NONE | hi Visual cterm=NONE guifg=Purple guibg=NONE
" :hi Search term=standout ctermfg=245 ctermbg=237 guifg=Purple guibg=#3c3836

" PLUGIN: NERDTree
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
let NERDTreeShowBookmarks = 1

function! NERDTreeToggleFind()
    if g:NERDTree.IsOpen()
        NERDTreeClose
    else
        if @% == '' || stridx(@%, '/bin/bash') != -1 || stridx(@%, '/bin/zsh') != -1
            NERDTree
        else
            NERDTreeFind
        endif
    endif
endfunction
com! NERDTreeToggleFind call NERDTreeToggleFind()
nnoremap <leader>n :NERDTreeToggleFind<CR>
nnoremap <leader>N :NERDTree<CR>


"PLUGIN: Winresizer
let g:winresizer_start_key = '<leader>w :WinResizerStartResize<CR>'
nnoremap <leader>w :WinResizerStartResize<CR>

" PLUGIN: Syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" PLUGIN: Jedi-Vim
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
let g:jedi#usages_command = "<leader>u"


" " PLUGIN: FZF
" Don't include file name in :Rg
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
nnoremap <leader>rg :Rg<CR>
" nnoremap <silent> <leader>f :Rg<CR>
nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>' :Marks<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <silent> <leader>H :Helptags<CR>
nnoremap <silent> <leader>hh :History<CR>
nnoremap <silent> <leader>h: :History:<CR>
nnoremap <silent> <leader>h/ :History/<CR>
