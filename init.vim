filetype off

call plug#begin(stdpath('data') . '/plugged')

" Pimped status line
Plug 'itchyny/lightline.vim'
Plug 'spywhere/lightline-lsp'

" Toggle quick/location list
Plug 'milkypostman/vim-togglelist'

" Color scheme and highlighter
Plug 'joshdick/onedark.vim'
Plug 'chuling/vim-equinusocio-material'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tsiemens/vim-aftercolors'
Plug 'bfrg/vim-cpp-modern'

" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Comment lines
Plug 'tpope/vim-commentary'

" Syntax
Plug 'dart-lang/dart-vim-plugin'
Plug 'udalov/kotlin-vim'
Plug 'leafgarland/typescript-vim'
Plug 'gburca/vim-logcat'
Plug 'keith/swift.vim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Neovim bultin lsp
Plug 'neovim/nvim-lsp'
Plug 'nvim-lua/completion-nvim'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

" Format multiple file types
Plug 'sbdchd/neoformat'

" Editor config
Plug 'editorconfig/editorconfig-vim'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

let g:equinusocio_material_style = 'darker'
"colorscheme equinusocio_material

let g:onedark_color_overrides = { "black": {"gui": "#121212", "cterm": "235", "cterm16": "0" } }
colorscheme onedark

" Disable colorscheme background
" autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

let mapleader = ','
syntax on

" General stuff
set nocompatible
set laststatus=2
set mouse=a
set backspace=2
set smartcase
set ruler
set scrolloff=4
set conceallevel=0
set fillchars+=vert:│

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set cindent

" Search
set hlsearch
set incsearch
set ignorecase

" Multi-replace
set inccommand=nosplit

" Undo
set undodir=~/.config/nvim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Swaps
set backupdir=~/.config/nvim/swaps
set directory=~/.config/nvim/swaps

" Default statusline
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=100

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Tab completion. Taken from nvim-completion README.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

inoremap <silent><expr> <c-space> completion#trigger_completion()

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=#FF4060
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red
autocmd InsertEnter * match ExtraWhiteSpace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

" Enter to remove search highlight or insert mode
nnoremap <cr> :nohlsearch<cr>/<bs>
autocmd InsertEnter * :set nohlsearch
autocmd InsertLeave * :set hlsearch

let g:LargeFile = 1024 * 1024 * 2
augroup LargeFile
 autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function LargeFile()
 " no syntax highlighting etc
 set eventignore+=FileType
 setlocal bufhidden=unload
 setlocal undolevels=-1
 " display message
 autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction


" Colorizer setup
lua require'colorizer'.setup()

" Highlight yanked text
au TextYankPost * silent! lua require'vim.highlight'.on_yank()

" Prioritize eslint-formatter for javascript
let g:neoformat_enabled_javascript = ['prettiereslint', 'js-beautify', 'clang-format']

" FZF
let $FZF_DEFAULT_OPTS='--layout=reverse --margin=1,3'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_preview_window = ['up:40%', 'ctrl-/']
nnoremap <silent> <leader>f :Files <cr>
nnoremap <silent> <leader>b :Buffers <cr>
nnoremap <silent> <leader>j :GFiles <cr>
nnoremap <silent> <leader>g :Rg <cr>
nnoremap <silent> <leader>G :Rg <c-r><c-w><cr>

" Lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ],
      \   'right': [['lineinfo'], ['percent'],
      \             ['linter_errors', 'linter_warnings',],
      \             ['fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'relativepath' ],
      \             [ ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }
      \ }

let g:lightline.component_expand = {
      \  'linter_hints': 'lightline#lsp#hints',
      \  'linter_infos': 'lightline#lsp#infos',
      \  'linter_warnings': 'lightline#lsp#warnings',
      \  'linter_errors': 'lightline#lsp#errors',
      \  'linter_ok': 'lightline#lsp#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_hints': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }

" CPP
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2

" Makefiles should use tabulators
autocmd FileType make setlocal shiftwidth=4 tabstop=4 noexpandtab

" Map that hard to type key
nmap ö [
nmap ä ]
omap ö [
omap ä ]
xmap ö [
xmap ä ]

" Copy to clipboard
vnoremap <leader>y "+y

" Navigation
nmap . .`[
nmap j gj
nmap k gk
nmap <c-h> :ClangdSwitchSourceHeader <CR>
nmap <F3> :e ~/.config/nvim/lua/init.lua <CR>
nmap <F4> :e ~/.config/nvim/init.vim <CR>

" Quickfix/location
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>

" Format file
nnoremap <leader>cf :Neoformat<CR>
vnoremap <leader>cf :Neoformat<CR>

" For easier searching
nnoremap - /
nnoremap _ ?

" Magically fold from search result
nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Highlight yanked text
augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Reset blinking mode when leaving
au VimLeave * set guicursor=a:block-blinkon1
au VimSuspend * set guicursor=a:block-blinkon1
au VimResume * set guicursor=a:block-blinkon0

" Always set lsp as omnifunc
autocmd BufEnter * lua require('init').attach_lsp()

" Load Custom Modules
lua << EOF
require('init')
EOF

