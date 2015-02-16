set nocompatible " Disable vi support
set nobackup " Disable the backup file (ends in '~')

" Seems to fix a bunch of problems with filetype plugins
filetype on
filetype off

set encoding=utf-8 " Assume UTF-8

set number " Show line numbers
set colorcolumn=121 " Show the margin
set ruler " Show the cursor position
set showcmd " Show the command at the bottom
set laststatus=2 " Always show the status bar at the bottom

set backspace=indent,eol,start " Allow backspace/delete past the beginning or end of the line

set smarttab " 'Shift' when at the beginning of the line; 'tab' otherwise
set expandtab " Spaces, not tabs
set autoindent " Indent according to the previous line
set smartindent " Indent or dedent automatically when opening and closing blocks
set shiftwidth=4 " Indent and dedent
set tabstop=4 " The distance travelled by the Tab key after characters

set linebreak " Wrap at a word boundary (doesn't work in list mode)

set incsearch " Search as you type
set ignorecase " Ignore case when searching
set smartcase " Search case-insensitively until a capital letter is typed
set hlsearch " Highlight search results in the document
" Type ',c' to clear search results
nnoremap ,c :let @/=""<CR>

set mouse=a " Let the user use the mouse

command W w " Bind ':W' to ':w'
command Q q " Bind ':Q' to ':q'
command Wq wq " Bind ':Wq' to ':wq'
command WQ wq " Bind ':WQ' to ':wq'
" Move up and down according to the printed lines, including wrapping, not physical lines
nnoremap j gj
nnoremap k gk
let mapleader=',' " The <Leader> in map operations is the ','

" Set up Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Bundle 'altercation/vim-colors-solarized'

" Git support
Bundle 'tpope/vim-fugitive'
" Extra functionality in the status bar
Bundle 'bling/vim-airline'
" Search files using Ctrl+P
Bundle 'kien/ctrlp.vim'
" File/directory management
Bundle 'scrooloose/nerdtree'

" Better repeat support with '.'
Bundle 'tpope/vim-repeat'
" Insert, delete and change surrounding elements ('(', '[', '<', etc.)
Bundle 'tpope/vim-surround'
" Comment with '\'
Bundle 'tpope/vim-commentary'
" 'f' and 't' across lines
Bundle 'dahu/vim-fanfingtastic'
" Move about with ','
Bundle 'Lokaltog/vim-easymotion'

Bundle 'tpope/vim-markdown'
Bundle 'derekwyatt/vim-scala'
Bundle 'guns/vim-clojure-static'
Bundle 'DrTom/fsharp-vim'
Bundle 'dag/vim2hs'
Bundle 'eagletmt/ghcmod-vim'
Bundle 'bitc/vim-hdevtools'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'noc7c9/vim-iced-coffee-script'
Bundle 'tpope/vim-haml'
Bundle 'digitaltoad/vim-jade'
Bundle 'slim-template/vim-slim'
Bundle 'lunaru/vim-less'
Bundle 'tpope/vim-liquid.git'

" Colour parentheses according to depth
Bundle 'kien/rainbow_parentheses.vim'
" Colour text denoting a CSS colour as itself
Bundle 'ap/vim-css-color'

" Interactive command execution
Bundle 'Shougo/vimproc.vim'
" Highlight errors
Bundle 'scrooloose/syntastic'
" Search across the JVM classpath
Bundle 'tpope/vim-classpath'
" Clojure REPL
Bundle 'tpope/vim-fireplace'
" Precision editing for S-expressions
Bundle 'guns/vim-sexp'

" Edit encrypted files
Bundle 'jamessan/vim-gnupg'

" Search for two characters with the ' key.
nmap ' <Plug>(easymotion-s2)
vmap ' <Plug>(easymotion-s2)

autocmd BufWritePre * :%s/\s\+$//e " Delete trailing spaces

" Show tabs, trailing spaces and lines that extend past the right of the screen
" Disable for text and Markdown files
set list!
set listchars=tab:->,trail:·,extends:>
autocmd Filetype text setlocal nolist
autocmd Filetype markdown setlocal nolist
autocmd Filetype markdown setlocal colorcolumn=0

" Show/hide NERDTree with <Tab>
map <Tab> :NERDTreeToggle<CR>
" Refresh the CtrlP cache with <F5>
map <F5> :CtrlPClearCache<CR>

set wildignore+=*.class,build,target " Ignore Java output
set wildignore+=_site " Ignore Jekyll output
set wildignore+=dist " Ignore Haskell output
set wildignore+=node_modules " Ignore local node.js dependencies

" Set up Solarized Dark
set t_Co=256
let g:solarized_termcolors=16
let g:Powerline_theme='solarized16'
set background=dark
colorscheme solarized

" Set the font
if has("mac")
    try
        set guifont=Source\ Code\ Pro\ Light:h14
    catch
        set guifont=Menlo:h14
    endtry
elseif has("unix")
    try
        set guifont=Source\ Code\ Pro\ Light:h14
    catch
        try
            set guifont=Inconsolata\ 12
        catch
        endtry
    endtry
elseif has("win32")
    set guifont=Consolas:h12
endif

function CheckForErrors()
    SyntasticCheck
    Errors
endfunction

noremap <Leader>e :call CheckForErrors()<CR>

noremap <Leader>l :lclose<CR>

autocmd FocusLost * update " Autosave whenever leaving a modified file, for any reason.

autocmd BufNewFile,BufRead *.ru set filetype=ruby
autocmd BufNewFile,BufRead *.gradle set filetype=groovy
autocmd BufNewFile,BufRead *.stylus set filetype=sass

autocmd Filetype clojure setlocal sw=2 ts=2 sts=2
autocmd Filetype coffee setlocal sw=2 ts=2 sts=2
autocmd Filetype coffee.iced-coffee setlocal sw=2 ts=2 sts=2
autocmd Filetype jade setlocal sw=2 ts=2 sts=2
autocmd Filetype ruby setlocal sw=2 ts=2 sts=2
autocmd Filetype scala setlocal sw=2 ts=2 sts=2
autocmd Filetype slim setlocal sw=2 ts=2 sts=2
autocmd Filetype yaml setlocal sw=2 ts=2 sts=2

autocmd BufNewFile,BufRead *.clj set macmeta
autocmd VimEnter *.clj RainbowParenthesesToggle
autocmd Syntax *.clj RainbowParenthesesLoadRound
autocmd Syntax *.clj RainbowParenthesesLoadSquare
autocmd Syntax *.clj RainbowParenthesesLoadBraces

let g:GPGPreferSymmetric=1 " Use symmetric GPG encryption with new files

filetype plugin indent on " Re-enable filetype detection with plugins and indentation
syntax enable " Enable syntax highlighting
