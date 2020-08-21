filetype off

call plug#begin('~/.config/nvim/plugged')

" Better motion
Plug 'justinmk/vim-sneak'

" Pimped status line
Plug 'itchyny/lightline.vim'

" Color scheme and highlighter
Plug 'chuling/vim-equinusocio-material'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tsiemens/vim-aftercolors'
Plug 'jackguo380/vim-lsp-cxx-highlight'

" git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'

" Fuzzy search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Comment lines
Plug 'tpope/vim-commentary'

" Syntax
Plug 'dart-lang/dart-vim-plugin'
Plug 'udalov/kotlin-vim'
Plug 'leafgarland/typescript-vim'
Plug 'gburca/vim-logcat'

" Neovim bultin lsp
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

" Format multiple file types
Plug 'sbdchd/neoformat'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

let g:equinusocio_material_style = 'darker'
colorscheme equinusocio_material

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
set textwidth=100
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

" Colorizer setup
lua require'colorizer'.setup()

" Highlight yanked text
au TextYankPost * silent! lua require'vim.highlight'.on_yank()

" Prioritize eslint-formatter for javascript
let g:neoformat_enabled_javascript = ['prettiereslint', 'js-beautify', 'clang-format']

" Lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'equinusocio_material',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'relativepath' ],
      \             [ ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }
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

" Navigation
nmap . .`[
nmap j gj
nmap k gk
nmap <c-j> :tjump 
nmap <c-h> :call SwitchSourceHeader() <CR>
nmap <F4> :e ~/.config/nvim/init.vim <CR>
nmap <F12> :tjump <C-R><C-W> <CR>
nmap <F12> :tjump <C-R><C-W> <CR>

" Fzf.vim
nnoremap <silent> <leader>f :Files <CR>
nnoremap <silent> <leader>b :Buffers <CR>
nnoremap <silent> <leader>j :GFiles <CR>
nnoremap <silent> <leader>t :Tags <CR>

" Quickfix/location
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>

" Diagnostics
nnoremap <leader>qn :NextDiagnosticCycle<CR>
nnoremap <leader>qp :PrevDiagnosticCycle<CR>

" override default f instead of s
map f <Plug>Sneak_s
map F <Plug>Sneak_S
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" Format file
nnoremap <leader>cf :Neoformat<CR>
vnoremap <leader>cf :Neoformat<CR>

" Generate new ctags for project
nmap <F8> :!ctags -R --c++-kinds=+p --fields=+ilaS --extras=+q+f .<CR>
nmap <C-F8> :!ctags -R --language-force=java --extras=+f --exclude=*.class .<CR>

" Change between indentation settings
nmap <F9> :set tabstop=4<CR>:set shiftwidth=4<CR>:set expandtab<CR>:set cinoptions=<CR>
nmap <F10> :set tabstop=2<CR>:set shiftwidth=2<CR>:set expandtab<CR>:set cinoptions=<CR>

" Magically fold from search result
nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

"Added ! to overwrite on reload
function! SwitchSourceHeader()
    let extension = expand("%:e")
    if extension ==? "cpp" || extension ==? "c"
        let extension = ".h"
    else
        let extension = ".c"
    endif
    let file = expand("%:t:r").extension
    if bufexists(bufname(file))
        execute "buffer ".file
    else
        execute "tjump ".file
    endif
endfunction

" Highlight yanked text
augroup LuaHighlight
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

" Reset blinking mode when leaving
au VimLeave * set guicursor=a:block-blinkon1
au VimSuspend * set guicursor=a:block-blinkon1
au VimResume * set guicursor=a:block-blinkon0

" Floating FZF
let $FZF_DEFAULT_OPTS='--layout=reverse --margin=1,3'
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" For nvim-completion
let g:completion_enable_auto_popup = 1
let g:completion_auto_change_source = 1

" Neovim LSP Diagnostics
let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_show_sign = 1
let g:diagnostic_auto_popup_while_jump = 1
let g:diagnostic_insert_delay = 1
let g:diagnostic_virtual_text_prefix = ' '

" Always set lsp as omnifunc
set omnifunc=v:lua.vim.lsp.omnifunc
autocmd BufEnter * lua require'completion'.on_attach()

" Load Custom Modules:
lua << EOF
require('init')
EOF

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gw    <cmd>lua vim.lsp.buf.workspace_symbol()<CR><c-r><c-w><CR>
nnoremap <silent> gF    <cmd>lua vim.lsp.buf.formatting()<CR>
