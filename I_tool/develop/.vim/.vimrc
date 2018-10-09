execute pathogen#infect()

set nocompatible

set backspace=indent,eol,start

set showmatch

set showmatch

set tabstop=4

set softtabstop=4

set shiftwidth=4

set helplang=cn

set fileencodings=ucs-bom,utf-8,utf-16,gbk,gb2312,big5,gb18030,latin1

set termencoding=utf-8

set encoding=utf-8

map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .

""call pathogen#infect()

syntax enable

syntax on

filetype plugin on

set number

let g:go_disable_autoinstall=0

let g:neocomplete#enable_at_startup = 1
"desert   "molokai
colorscheme darkblue

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds' : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

"==============================
"
"==============================
nmap <F8> :TagbarToggle<CR>

"map <C-n> :NERDTreeToggle<CR>
"map <F3> :e . <CR>

"==============================
"==============================
let g:winManagerWindowLayout='FileExplorer|TagbarToggle'
nmap <F2> :WMToggle<CR>


"===============================
"===============================
set modifiable
set write

let g:netrw_alto = 1

let g:netrw_browse_split = 1

syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set cindent
set nu
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap < <><ESC>i
:inoremap > <c-r>=ClosePair('>')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
function ClosePair(char)
 if getline('.')[col('.') - 1] == a:char
   return "/<Right>"
 else
   return a:char
 endif
endf

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'fatih/vim-go'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set nu

