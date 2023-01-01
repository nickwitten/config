set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    if !has('nvim')
        set ttymouse=xterm2
    endif
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
set number relativenumber
set hls
set modelines=0
set clipboard^=unnamed,unnamedplus
"set clipboard=unnamed

if has("win32")
    set shell=powershell
    set shellcmdflag=-command
    if !has("nvim")
        set termwintype=conpty  " fixes issues with terminal colors and ctrl-c
    endif
    set guifont=Consolas:h9:cANSI
end


let mapleader = " "
map <leader>rc :source $MYVIMRC<CR>
" Scroll with and without cursor
nnoremap <c-j> j<c-e>
nnoremap <c-k> k<c-y>
" Tabs
nnoremap H gT
nnoremap L gt
nnoremap <c-h> :tabm -1<CR>
nnoremap <c-l> :tabm +1<CR>
nnoremap <c-n> :tabnew<CR>
nnoremap <c-x> :tabclose<CR>
" Paste register 0
nnoremap P "0p
" Cut to register 0
nnoremap X "0x
xnoremap X "0x
" Terminal mappings
nnoremap <leader>T :tab term<CR>
if has('nvim')
    tnoremap <c-w>[ <c-\><c-n>:setlocal norelativenumber nonumber<CR>:echo<CR>
    tnoremap <c-w>c <c-\><c-n>
else
    tnoremap <c-w>[ <c-w>N:setlocal norelativenumber nonumber<CR>:echo<CR>
    tnoremap <c-w>c <c-w>N
endif
" Search
nnoremap * *N
vnoremap * "ay :exe 'Search '.@a<CR> NN
vnoremap c* "ay :exe 'Search '.@a<CR> NN cgn
nnoremap # :noh<CR>:echo<CR>
nnoremap c* *N cgn
com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\/')| normal! n
" Folds
set foldmethod=indent
set foldlevelstart=99  " don't open a buffer with folds closed
nnoremap <leader>f za
nnoremap <leader>F zO
nnoremap <leader>af zM
nnoremap <leader>uf zR
" Paste mode
nnoremap <leader>v :set paste<CR>"*p:set nopaste<CR>
" Redraw
nnoremap <leader>! :redraw!<CR>
vnoremap < <gv
vnoremap > >gv
" Emacs bindings in command mode
:cnoremap <C-A>  <Home>
:cnoremap <C-B>  <Left>
:cnoremap <C-D>  <Del>
:cnoremap <C-E>  <End>
:cnoremap <C-F>  <Right>
:cnoremap <C-N>  <Down>
:cnoremap <C-P>  <Up>
:cnoremap <Esc>b <S-Left>
:cnoremap <Esc>f <S-Right>


" Include library tags
" set tags+=/usr/include/**/tags
" set tags+=/usr/lib/**/tags
" set tags+=/usr/local/include/**/tags
" set tags+=/usr/local/lib/**/tags
" if has("unix")
"     set tags+=$HOME/.local/lib/**/tags
" else
"     set tags+=$LOCALAPPDATA/Programs/Python/**/tags  " Not tested
" endif


" Swap, undo, and backup clutter
silent! call mkdir ($HOME.'/.vim/backup', 'p')
set backupdir=~/.vim/backup//
silent! call mkdir ($HOME.'/.vim/undo', 'p')
set undodir=~/.vim/undo//
silent! call mkdir ($HOME.'/.vim/swap', 'p')
set directory=~/.vim/swap//


function! EditCursorPath(newtab)
    let cursorpath = expand("<cfile>:p")
    if isdirectory(cursorpath)
        execute("cd " . cursorpath)
        echo cursorpath
        return
    endif
    if filereadable(cursorpath)
        if exists('*floaterm#window#hide')
            call floaterm#window#hide(bufnr(""))
        endif
        if a:newtab
            tabnew
        endif
        execute("edit " . cursorpath)
        return
    endif
    echo "Could not find dir/file"
endfunction
nnoremap gf :call EditCursorPath(0)<CR>
nnoremap <c-w>gf :call EditCursorPath(1)<CR>


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
autocmd VimEnter * call SaveCWD()


function! ChangeSavedCWD()
    if exists("g:SavedCWD")
        execute("cd " . g:SavedCWD)
        echo g:SavedCWD
    else
        echo "No saved directory"
    endif
endfunction
nnoremap <leader>csd :call ChangeSavedCWD()<CR>


function! ChangeCWD()
    " let cursorpath = expand("<cfile>")
    " let fullpath = expand(cursorpath)
    " if isdirectory(fullpath)
    "     execute("cd " . fullpath)
    "     echo fullpath
    " else
    if has("unix")
        silent! let term_path = resolve("/proc/" . bufnr("")->term_getjob()->job_info()["process"] . "/cwd")
        if isdirectory(term_path)
            execute("cd " . term_path)
            echo term_path
        else
            let file_path = expand("%:p:h")
            if isdirectory(file_path)
                execute("cd " . file_path)
                echo file_path
            else
                echo "No directory associated with buffer"
            endif
        endif
    else
        echo "Only implemented for unix"
    endif
endfunction
" Switch to current path under cursor
" nnoremap <leader>cd :cd <cfile><CR>:echo expand("<cfile>")<CR>
nnoremap <leader>cd :call ChangeCWD()<CR>


function! FindInTermCWD(cmd)
    if has("unix")
        silent! let path = resolve("/proc/" . bufnr("")->term_getjob()->job_info()["process"] . "/cwd")
        if exists('*floaterm#window#hide')
            call floaterm#window#hide(bufnr(""))
        endif
        execute(a:cmd . " " . path)
    else
        echo "Only implemented for unix"
    endif
endfunction


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


function! InPlace()
    " Either open a new terminal here or if
    " in nerdtree, sync with global cwd
    if exists('t:NERDTreeBufName') && buffer_name("") == t:NERDTreeBufName
        NERDTreeCWD
        echo getcwd()
    else
        call OpenTermInPlace()
    endif
endfunction


function! OpenTermInPlace()
    let curr_buf = bufnr("")
    if curr_buf->term_getstatus() == "running,normal"
        call bufnr("")->term_getjob()->job_stop("kill")
    endif
    term
    execute "bd! ".curr_buf
endfunction
nnoremap <leader>i :call InPlace()<CR>


function! RC()
    tabnew
    e ~/config/.vimrc
    vnew ~/config/.zshrc
endfunction
com! RC call RC()


function! Swaps()
    execute "vnew " . &directory
endfunction
com! Swaps call Swaps()


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
    let bufnr = bufnr("")
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
    execute "sbuff " . bufnr
endfunction
com! -nargs=1 MoveBuff call MoveBuff(<f-args>)
nnoremap <leader><c-l> :MoveBuff r<CR>
nnoremap <leader><c-h> :MoveBuff l<CR>


function! MaximizeCurrBuf()
    let bufnr = bufnr("")
    if exists('*floaterm#window#hide')
        call floaterm#window#hide(bufnr(""))
    endif
    silent! tabnew
    silent! execute "buf " . bufnr
endfunction
nnoremap <c-w>z :call MaximizeCurrBuf()<CR>
tnoremap <c-w>z <c-w>:call MaximizeCurrBuf()<CR>




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
Plug 'tpope/vim-surround',
Plug 'nickwitten/vim-floaterm',
" PLUGIN: Plug 'vim-syntastic/syntastic'
call plug#end()


" PLUGIN: Gruvbox
let g:gruvbox_contrast_dark = 'hard'
set termguicolors
" Set gruvbox colors in the terminal, gruvbox does this but we want all
" bright versions
if has('nvim')
    autocmd ColorScheme * nested let g:terminal_color_0 = '#282828' | let g:terminal_color_1 = '#FB4934' | let g:terminal_color_2 = '#8EC07C' | let g:terminal_color_3 = '#FABD2F' | let g:terminal_color_4 = '#83A598' | let g:terminal_color_5 = '#9c1dcf' | let g:terminal_color_6 = '#8EC07C' | let g:terminal_color_7 = '#928374' | let g:terminal_color_8 = '#282828' | let g:terminal_color_9 = '#FB4934' | let g:terminal_color_10 = '#B8BB26' | let g:terminal_color_11 = '#FABD2F' | let g:terminal_color_12 = '#83A598' | let g:terminal_color_13 = '#D3869B' | let g:terminal_color_14 = '#8EC07C' | let g:terminal_color_15 = '#A89984'
else
    let g:terminal_ansi_colors = ['#282828', '#FB4934', '#8EC07C', '#FABD2F', '#83A598', '#9c1dcf', '#8EC07C', '#928374', '#282828', '#FB4934', '#B8BB26', '#FABD2F', '#83A598', '#D3869B', '#8EC07C', '#A89984']
end
" Highlight colors
if has('nvim')
    autocmd ColorScheme * nested hi Search guifg=bg guibg=#9c1dcf | hi IncSearch guifg=bg guibg=#9c1dcf | hi Visual guifg=bg guibg=#9c1dcf
else
    autocmd! ColorScheme * hi clear CursorLine | hi Search cterm=NONE guifg=Purple guibg=NONE | hi IncSearch cterm=NONE guifg=Purple guibg=NONE | hi Visual cterm=NONE guifg=Purple guibg=NONE
end
autocmd vimenter * nested colorscheme gruvbox
set background=dark
set nocursorline


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
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <C-f> :Files<CR>
tnoremap <silent> <c-w>f <c-w>:call FindInTermCWD("Files")<CR>
nnoremap <silent> <leader>rg :Rg<CR>
nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>/ :BLines<CR>
nnoremap <silent> <leader>' :Marks<CR>
nnoremap <silent> <leader>g :Commits<CR>
nnoremap <silent> <leader>H :Helptags<CR>
nnoremap <silent> <leader>hh :History<CR>
nnoremap <silent> <leader>h: :History:<CR>
nnoremap <silent> <leader>h/ :History/<CR>
" Access registers in FZF pop-up
autocmd! FileType fzf tnoremap <expr> <C-r> getreg(nr2char(getchar()))
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:55%' --layout reverse --margin=1,4"
let $FZF_DEFAULT_COMMAND = 'rg -L --files --no-ignore --hidden --smart-case --glob "!{.git,node_modules,vendor}/*"'
command! -bang -nargs=* Rg
    \ call fzf#vim#grep("rg -L --no-ignore --hidden --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)


" PLUGIN: FLoatTerm
nnoremap <c-q> :FloatermToggle<CR>
if has('nvim')
    tnoremap <c-q> <c-\><c-n>:FloatermToggle<CR>
    nnoremap <c-w><c-n> :FloatermNew<CR>
    tnoremap <c-w><c-n> <c-\><c-n>:FloatermNew<CR>
    tnoremap <c-w><c-h> <c-\><c-n>:FloatermPrev<CR>
    tnoremap <c-w><c-l> <c-\><c-n>:FloatermNext<CR>
    tnoremap <c-w><c-k> <c-\><c-n>:FloatermKill<CR>
else
    tnoremap <c-q> <c-w>:FloatermToggle<CR>
    nnoremap <c-w><c-n> :FloatermNew<CR>
    tnoremap <c-w><c-n> <c-w>:FloatermNew<CR>
    tnoremap <c-w><c-h> <c-w>:FloatermPrev<CR>
    tnoremap <c-w><c-l> <c-w>:FloatermNext<CR>
    tnoremap <c-w><c-k> <c-w>:FloatermKill<CR>
endif
let g:floaterm_height = 0.8
let g:floaterm_width = 0.8
let g:floaterm_autoclose = 2  " Always close after job exits
autocmd ColorScheme * nested hi FloatermBorder guibg=NONE

