set nocompatible
set nobackup

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

syntax on

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

map <Tab> :NERDTreeToggle<CR>

filetype off
filetype plugin indent on

au BufNewFile,BufRead *.ru set filetype=ruby
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

au BufNewFile,BufRead *.stylus set filetype=sass
autocmd Filetype sass setlocal ts=4 sts=4 sw=4
