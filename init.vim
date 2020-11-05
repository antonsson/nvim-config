filetype off

call plug#begin(stdpath('data') . '/plugged')

" Turn off highlight search when done
Plug 'romainl/vim-cool'

" Pimped status line
Plug 'itchyny/lightline.vim'

" Toggle quick/location list
Plug 'milkypostman/vim-togglelist'

" Color scheme and highlighter
Plug 'sainnhe/sonokai'
Plug 'joshdick/onedark.vim'
Plug 'chuling/vim-equinusocio-material'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'tsiemens/vim-aftercolors'
Plug 'nvim-treesitter/nvim-treesitter'
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

" Neovim bultin lsp
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

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

let g:sonokai_style = 'andromeda'
let g:sonokai_transparent_background = 1
"colorscheme sonokai

let g:onedark_color_overrides = { "black": {"gui": "#181818", "cterm": "235", "cterm16": "0" } }
colorscheme onedark

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
nmap <c-h> :ClangdSwitchSourceHeader <CR>
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

" For nvim-diagnostics
call sign_define("LspDiagnosticsErrorSign", {"text" : "x", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "w", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "i", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

" Always set lsp as omnifunc
autocmd BufEnter * lua require('init').attach_lsp()

" Load Custom Modules
lua << EOF
require('init')
EOF

