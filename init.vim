filetype off

call plug#begin(stdpath('data') . '/plugged')

" Turn off highlight search when done
Plug 'romainl/vim-cool'

" Pimped status line
Plug 'itchyny/lightline.vim'

" Toggle quick/location list
Plug 'milkypostman/vim-togglelist'

" Color scheme and highlighter
Plug 'chuling/vim-equinusocio-material'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tsiemens/vim-aftercolors'
Plug 'nvim-treesitter/nvim-treesitter'

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

" Neovim bultin lsp
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

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
nmap <F3> :e ~/.config/nvim/lua/init.lua <CR>
nmap <F4> :e ~/.config/nvim/init.vim <CR>
nmap <F12> :tjump <C-R><C-W> <CR>
nmap <F12> :tjump <C-R><C-W> <CR>

" Quickfix/location
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>

" Diagnostics
nnoremap <leader>n :NextDiagnosticCycle<CR>
nnoremap <leader>p :PrevDiagnosticCycle<CR>
nnoremap <leader>i :lua vim.lsp.util.show_line_diagnostics()<CR>

" Format file
nnoremap <leader>cf :Neoformat<CR>
vnoremap <leader>cf :Neoformat<CR>

" Generate new ctags for project
nmap <F8> :!ctags -R --c++-kinds=+p --fields=+ilaS --extras=+q+f .<CR>
nmap <C-F8> :!ctags -R --language-force=java --extras=+f --exclude=*.class .<CR>

" Change between indentation settings
nmap <F9> :set tabstop=4<CR>:set shiftwidth=4<CR>:set expandtab<CR>:set cinoptions=<CR>
nmap <F10> :set tabstop=2<CR>:set shiftwidth=2<CR>:set expandtab<CR>:set cinoptions=<CR>

" For easier searching
nnoremap - /
nnoremap _ ?

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

" For nvim-completion
imap <c-j> <Plug>(completion_next_source)
imap <c-k> <Plug>(completion_prev_source)
call sign_define("LspDiagnosticsErrorSign", {"text" : "x", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "w", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "i", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

" Always set lsp as omnifunc
set omnifunc=v:lua.vim.lsp.omnifunc
autocmd BufEnter * lua require'completion'.on_attach()

" Load Custom Modules
lua << EOF
require('init')
EOF

" Nvim LSP mappings
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>

" Telescope mappings
nnoremap <leader>f :lua require'telescope.builtin'.find_files{}<cr>
nnoremap <leader>j :lua require'telescope.builtin'.git_files{}<cr>
nnoremap <leader>g :lua require'telescope.builtin'.live_grep{}<cr>
nnoremap <leader>b :lua require'telescope.builtin'.buffers{}<cr>
nnoremap <leader>r :lua require'telescope.builtin'.lsp_references{}<cr>
nnoremap <leader>w :lua require'telescope.builtin'.lsp_workspace_symbols{}<cr>
