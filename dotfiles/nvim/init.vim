set nocompatible " Disable vi support
set nobackup " Disable the backup file (ends in '~')
set nowritebackup

let mapleader=',' " The <Leader> in map operations is the ','
let maplocalleader=';' " The <LocalLeader> in map operations is the ';'

set encoding=utf-8 " Assume UTF-8

set colorcolumn=81,121 " Show the margin
set signcolumn=yes " Always show the sign column
set number " Show line numbers
set showcmd " Show the command at the bottom
set laststatus=2 " Always show the status bar at the bottom

set expandtab " Spaces, not tabs
set smartindent " Indent or dedent automatically when opening and closing blocks
set shiftwidth=2 " Indent and dedent
set tabstop=2 " Number of spaces that a <Tab> counts for
set softtabstop=2 " The distance travelled by the Tab key after characters

set linebreak " Wrap at a word boundary (doesn't work in list mode)

set ignorecase " Ignore case when searching
set smartcase " Search case-insensitively until a capital letter is typed
set hlsearch " Highlight search results in the document

set cursorline
set scrolloff=5
set mouse=a " Let the user use the mouse

command W w " Bind ':W' to ':w'
command Q q " Bind ':Q' to ':q'
command Wq wq " Bind ':Wq' to ':wq'
command WQ wq " Bind ':WQ' to ':wq'
" Move up and down according to the printed lines, including wrapping, not physical lines
nnoremap j gj
nnoremap k gk
set pastetoggle=<F2> " F2 toggles paste mode

" Set up plugins
call plug#begin(stdpath('data') . '/plugged')

" Asynchronous execution (required by ghcmod-vim)
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Extra functionality in the status bar
Plug 'itchyny/lightline.vim'
" Search files with fzf
Plug 'junegunn/fzf', { 'dir': stdpath('config') . '/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" File/directory management
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
" Git support
Plug 'tpope/vim-fugitive'
" EditorConfig support
Plug 'editorconfig/editorconfig-vim'
" Connect up tmux
Plug 'christoomey/vim-tmux-navigator'

" Better repeat support with '.'
Plug 'tpope/vim-repeat'
" Insert, delete and change surrounding elements ('(', '[', '<', etc.)
Plug 'tpope/vim-surround'
" Comment with '\'
Plug 'tpope/vim-commentary'
" Precision editing for S-expressions
Plug 'guns/vim-sexp'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-cucumber'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'flowtype/vim-flow'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'Quramy/tsuquyomi'
Plug 'elmcast/elm-vim'
Plug 'lunaru/vim-less'
Plug 'tpope/vim-liquid'
Plug 'LnL7/vim-nix'
Plug 'ekalinin/Dockerfile.vim'
Plug 'hashivim/vim-hashicorp-tools'

" Lint
Plug 'w0rp/ale'
" Auto-format
Plug 'sbdchd/neoformat'

" Edit encrypted files
Plug 'jamessan/vim-gnupg'

call plug#end()

syntax enable

" In Neovim, <C-h> generates a backspace. We want it to do the right thing.
nmap <BS> <C-h>

" Yank, without jank.
vnoremap <expr>y "my\"" . v:register . "y`y"

" Status bars.
set noshowmode
set laststatus=2
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'fugitive', 'readonly', 'filepath', 'modified' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  \ },
  \ 'component': {
  \   'filepath': '%f',
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' }
\ }

function! LightlineFugitive()
  if exists("*fugitive#head")
      let branch = fugitive#head()
     return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

" Map Ctrl+P to fzf's files view.
nnoremap <C-p> :GFiles<CR>
nnoremap <C-o> :GFiles?<CR>

" Auto-format on save.
let g:neoformat_basic_format_trim = 1
let g:neoformat_enabled_haskell = ['ormolu']
let g:neoformat_enabled_html = []
let g:neoformat_enabled_javascript = ['prettier']
let g:clj_fmt_autosave = 1
let g:terraform_fmt_on_save = 1
augroup format
  autocmd BufWritePre * silent! Neoformat
augroup END

" Show tabs, trailing spaces and lines that extend past the right of the screen
" Disable for text and Markdown files
set list!
set listchars=tab:\ \ ,trail:·,extends:>
autocmd FileType text setlocal nolist
autocmd FileType markdown setlocal nolist colorcolumn=0

" Spellcheck text and markdown files
set spelllang=en_gb
autocmd FileType text setlocal spell
autocmd FileType markdown setlocal spell

" Show/hide NERDTree with <§>, and find the current file with <±>
map § :NERDTreeToggle<CR>
map ± :NERDTreeFind<CR>

" Show hidden files in NERDTree.
let NERDTreeShowHidden=1

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

autocmd BufNew * set bufhidden=delete " Don't keep files around in memory.
autocmd BufEnter,FocusGained * checktime " Auto-load the file if it's changed.
autocmd BufLeave,FocusLost * silent! update " Auto-save the file.
let g:tmux_navigator_save_on_switch = 1

" Language-specific configuration
let g:vim_markdown_folding_disabled = 1
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0
let g:flow#enable = 1
let g:flow#autoclose = 1
let g:elm_setup_keybindings = 0

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" LSP configuration.
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

" Auto-lint and fix.
nnoremap <Leader>n :ALENextWrap<CR>
nnoremap <Leader>N :ALEPreviousWrap<CR>
nnoremap <Leader>e :ALEDetail<CR>
nnoremap <Leader>f :Neoformat<CR>:ALEFix<CR>
let g:ale_linters = {
  \   'haskell': ['stack-build', 'ghc', 'hlint'],
  \}
let g:ale_fixers = {
  \   'javascript': ['eslint'],
  \   'javascript.jsx': ['eslint'],
  \   'haskell': [
  \     {-> {'command': ale#Escape('ormolu')}},
  \   ],
  \   'nix': [
  \     {-> {'command': ale#Escape('nixpkgs-fmt')}},
  \   ],
  \}
let g:ale_fix_on_save = 1

autocmd BufNewFile,BufRead Guardfile,*.Guardfile set filetype=ruby
autocmd BufNewFile,BufRead *.ru set filetype=ruby
autocmd BufNewFile,BufRead *.gradle set filetype=groovy
autocmd BufNewFile,BufRead *.stylus set filetype=sass
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.jsx
autocmd BufNewFile,BufRead elm-package.json let b:neoformat_json_jq = {
      \   'exe': 'jq',
      \   'args': ['--indent', '4', '.'],
      \   'stdin': 1,
      \ }
autocmd FileType bzl,java,groovy,kotlin,make,python
      \ setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal colorcolumn=80
autocmd FileType gitcommit setlocal colorcolumn=73

autocmd VimEnter *.clj RainbowParenthesesToggle
autocmd Syntax *.clj RainbowParenthesesLoadRound
autocmd Syntax *.clj RainbowParenthesesLoadSquare
autocmd Syntax *.clj RainbowParenthesesLoadBraces

function! ClearHighlights()
  if &ft == 'haskell' && exists(':GhcModTypeClear')
    GhcModTypeClear
  endif
endfunction

" Set up shortcuts for running the build and tests.
" This depends on the user running the `watch-it` script in another window.
function! WriteToWatchFile(commands)
  let file = substitute(system("tmux display-message -p '/tmp/watching-it-#{session_id}-#{window_index}'"), '[[:cntrl:]]', '', 'g')
  update
  call writefile(['set -e'] + a:commands, file)
endfunction

function! Build()
  if exists('g:build_commands')
    let commands = g:build_commands
  elseif file_readable('Makefile')
    let commands = ['make']
  elseif file_readable('stack.yaml')
    let commands = ['stack build']
  elseif file_readable('Setup.hs')
    let commands = ['cabal build']
  endif
  if exists('commands')
    call WriteToWatchFile(commands)
  else
    echoerr("I don't know how to build this repository.")
  endif
endfunction

function! RunTest()
  if exists('g:test_commands')
    let commands = g:test_commands
  elseif file_readable('Makefile')
    let commands = ['if [[ $(set +e; make -q check >& /dev/null; echo $?) -ne 2 ]]', 'then', 'make check', 'else', 'make test', 'fi']
  elseif file_readable('stack.yaml')
    let commands = ['stack test']
  elseif file_readable('Setup.hs')
    let commands = ['cabal build', 'cabal test']
  elseif file_readable('Rakefile')
    let commands = ['rake']
  elseif file_readable('Gemfile')
    let commands = ['rspec --color']
  elseif file_readable('package.json')
    let commands = ['npm test']
  endif
  if exists('commands')
    call WriteToWatchFile(commands)
  else
    echoerr("I don't know how to run the tests for this repository.")
  endif
endfunction

function! CheckType()
  if &ft == 'haskell'
    GhcModType
  elseif !empty(matchstr(&ft, '^javascript'))
    FlowType
  elseif !empty(matchstr(&ft, '^typescript'))
    echo tsuquyomi#hint()
  endif
endfunction

function! InsertType()
  if &ft == 'haskell'
    GhcModTypeInsert
  endif
endfunction

noremap <Leader>x :lclose<CR>:cclose<CR>
noremap <Leader>z :windo update<CR>:tabclose<CR>
noremap <Leader>c :nohlsearch<CR>:call ClearHighlights()<CR>
noremap <Leader>b :call Build()<CR>
noremap <Leader>t :call RunTest()<CR>
noremap <Leader>p :call CheckType()<CR>
noremap <Leader>P :call InsertType()<CR>

let g:GPGPreferSymmetric=1 " Use symmetric GPG encryption with new files

if getcwd() != $HOME && filereadable('.vimrc')
  let output = system('egrep ' . shellescape('^' . getcwd() . '$') . ' ~/.vimautosource')
  if ! v:shell_error
    execute 'source' (getcwd() . '/' . '.vimrc')
  endif
endif
