set nocompatible
set nobackup

filetype on
filetype off

set number
set ruler
set showcmd

set backspace=indent,eol,start

set smarttab
set expandtab
set autoindent
set shiftwidth=4
set tabstop=4
set softtabstop=4

set mouse=a 
command W w
command Q q
command Wq wq
command WQ wq

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-commentary'
Bundle 'scrooloose/nerdtree'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'tpope/vim-markdown'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-haml'
Bundle 'lunaru/vim-less'
Bundle 'VimClojure'
Bundle 'DrTom/fsharp-vim'
Bundle 'skammer/vim-css-color'

map <Tab> :FufFile **/<CR>
map <S-Tab> :NERDTreeToggle<CR>

filetype plugin indent on
syntax enable

set background=dark
colorscheme solarized

au BufNewFile,BufRead *.ru set filetype=ruby
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

autocmd Filetype clojure setlocal ts=2 sts=2 sw=2

au BufNewFile,BufRead *.gradle set filetype=groovy

au BufNewFile,BufRead *.stylus set filetype=sass
