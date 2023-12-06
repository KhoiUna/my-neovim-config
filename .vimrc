set encoding=utf8
set relativenumber
set number

" Spell check
set spelllang=en_us

" Setting dark mode
set background=dark 
autocmd vimenter * ++nested colorscheme gruvbox

" Set tab as chars
set list
set listchars=tab:>-

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
" set cursorcolumn

" Set tab width to 4 columns.
set tabstop=4
set shiftwidth=4 smarttab

" Disable mouse
set mouse=

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'

" Theme
Plug 'morhetz/gruvbox'

" Go formatter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/go.nvim'
Plug 'ray-x/guihua.lua' 

" Terminal emulator
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Find keyword
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Find files plugin - Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }

" Prettier - post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Auto-focusing & auto-resizing split windows
Plug 'nvim-focus/focus.nvim'

call plug#end()
" }}}

" KEYS MAPPINGS ------------------------------------------------------- {{{
" Open terminal bottom right
nnoremap <leader>t :botright 5sp \| term<CR>:set norelativenumber<CR>:set nospell<CR>

" Key mapping to copy current file path
nnoremap <leader>cp :let @+=expand('%:p')<CR>

" Turn off highlight
nnoremap th :noh<CR>

" Toggle spell checking
nnoremap ts :setlocal spell! spelllang=en_us<CR>

" Ctrl+S to save file
nnoremap <C-s> :w<CR>
" Ctrl+Q to quit file 
nnoremap <C-q> :q<CR>

" Config NERDTree
let NERDTreeShowHidden=1
nnoremap fn :NERDTreeFocus<CR>
nnoremap tn :NERDTreeToggle<CR>
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Config Telescope - Find files using Telescope command-line sugar.
noremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Use TAB to autocomplete
inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"
inoremap <silent><expr> <cr> "\<c-g>u\<CR>"
" }}}

lua <<EOF
-- Run gofmt on save
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').gofmt()
  end,
  group = format_sync_grp,
})
require('go').setup()

EOF
