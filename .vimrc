if has('win32')
    set shell=powershell
    set shellcmdflag=-command
    set shellquote=\"
    set termwintype=conpty
endif


set mouse=a
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


let mapleader = " "
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
" Terminal mappings
nnoremap <leader>T :tab term<CR>
tnoremap <c-w>[ <c-w>N:setlocal norelativenumber nonumber<CR>:echo<CR>
" Search
com! -nargs=1 Search :let @/='\V'.escape(<q-args>, '\/')| normal! n
nnoremap * *N
vnoremap * "ay :exe 'Search '.@a<CR> NN
vnoremap c* "ay :exe 'Search '.@a<CR> NN cgn
nnoremap c* *N cgn
nnoremap # :noh<CR>:echo<CR>
" Folds
set foldmethod=indent
set foldlevelstart=99  " don't open a buffer with folds closed
nnoremap <leader>f za
nnoremap <leader>F zO
nnoremap <leader>af zM
nnoremap <leader>uf zR
" Redraw
nnoremap <leader>! :redraw!<CR>
" Visual rehighlight
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


call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'simeji/winresizer'
Plug 'gcmt/taboo.vim'
Plug 'tpope/vim-surround'
call plug#end()



" PLUGIN: Gruvbox
let g:gruvbox_contrast_dark = 'hard'
set termguicolors
" Set gruvbox colors in the terminal, gruvbox does this but we want all
" bright versions
let g:terminal_ansi_colors = ['#282828', '#FB4934', '#8EC07C', '#FABD2F', '#83A598', '#9c1dcf', '#8EC07C', '#928374', '#282828', '#FB4934', '#B8BB26', '#FABD2F', '#83A598', '#D3869B', '#8EC07C', '#A89984']
" Highlight colors
autocmd! ColorScheme * hi clear CursorLine | hi Search cterm=NONE guifg=Purple guibg=NONE | hi IncSearch cterm=NONE guifg=Purple guibg=NONE | hi Visual cterm=NONE guifg=Purple guibg=NONE
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

