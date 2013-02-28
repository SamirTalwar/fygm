set nocompatible
set nobackup

filetype on
filetype off

set encoding=utf-8

set number
set ruler
set laststatus=2
set showcmd
set colorcolumn=121

set backspace=indent,eol,start

set smarttab
set expandtab
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4

set linebreak

set mouse=a

command W w
command Q q
command Wq wq
command WQ wq
let mapleader=','

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'

Bundle 'altercation/vim-colors-solarized'

Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'

Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-commentary'
Bundle 'dahu/vim-fanfingtastic'

Bundle 'tpope/vim-markdown'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'closetag.vim'
Bundle 'tpope/vim-haml'
Bundle 'slim-template/vim-slim'
Bundle 'lunaru/vim-less'
Bundle 'VimClojure'
Bundle 'paredit.vim'
Bundle 'DrTom/fsharp-vim'
Bundle 'skammer/vim-css-color'

autocmd BufWritePre * :%s/\s\+$//e

set list!
set listchars=tab:->,trail:·,extends:>
autocmd Filetype text setlocal nolist
autocmd Filetype markdown setlocal nolist
autocmd Filetype markdown setlocal colorcolumn=0

map <Tab> :NERDTreeToggle<CR>
map <F5> :CtrlPClearCache<CR>:! ctags -R .<CR><CR>

set wildignore+=*.class,bin,target

filetype plugin indent on
syntax enable

set t_Co=256
let g:solarized_termcolors=16
let g:Powerline_theme = 'solarized16'
set background=dark
colorscheme solarized

if has("mac")
    set guifont=Menlo:h12
elseif has("unix")
    set guifont=Inconsolata\ 12
elseif has("win32")
    set guifont=Consolas:h12
endif

au BufNewFile,BufRead *.ru set filetype=ruby
au BufNewFile,BufRead *.gradle set filetype=groovy
au BufNewFile,BufRead *.stylus set filetype=sass

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype clojure setlocal ts=2 sts=2 sw=2
autocmd Filetype coffee setlocal ts=2 sts=2 sw=2
