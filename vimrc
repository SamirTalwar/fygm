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

set linebreak

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
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'tpope/vim-markdown'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-haml'
Bundle 'bbommarito/vim-slim.git'
Bundle 'lunaru/vim-less'
Bundle 'VimClojure'
Bundle 'DrTom/fsharp-vim'
Bundle 'skammer/vim-css-color'

autocmd BufWritePre * :%s/\s\+$//e

set list!
set listchars=tab:->,trail:·,extends:>

map <Tab> :FufFile **/<CR>
map <S-Tab> :NERDTreeToggle<CR>

filetype plugin indent on
syntax enable

set t_Co=16
let g:solarized_termcolors=16
set background=dark
colorscheme solarized

if has("unix")
    set guifont=Inconsolata\ 12
elseif has("win32")
    set guifont=Consolas:h12
endif

map <F5> :FufRenewCache<CR>:! ctags -R .<CR><CR>

au BufNewFile,BufRead *.ru set filetype=ruby
au BufNewFile,BufRead *.gradle set filetype=groovy
au BufNewFile,BufRead *.stylus set filetype=sass

autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
autocmd Filetype clojure setlocal ts=2 sts=2 sw=2
autocmd Filetype coffee setlocal ts=2 sts=2 sw=2
