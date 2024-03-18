set encoding=utf8
set relativenumber
set number
set autoread
set linebreak

" Spell check
set spelllang=en_us

" Setting dark mode
set background=dark 
autocmd vimenter * ++nested colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=none

" Set tab as chars
"set list
"set listchars=tab:>-

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

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

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

" Toggle markdown preview
nnoremap md :MarkdownPreviewToggle<CR>

" Toggle line relativenumber & number
nnoremap tl :set invrelativenumber!<CR>:set invnumber!<CR>

" <Tab> to switch next tabs
nnoremap <C-i> gt
" Shift + <Tab> to switch to prev tabs
nnoremap <S-Tab> gT 
" Open a new tab
nnoremap <C-n> :tabnew<CR>

" Show ESLint warnings 
nnoremap es :ALEDetail<CR>

" Ctrl + T to tabnew
nnoremap <C-s> :Ag<CR>

" Move between split windows
nnoremap mk <C-w>k
nnoremap mj <C-w>j
nnoremap mh <C-w>h
nnoremap ml <C-w>l

" Config NERDTree
let NERDTreeShowHidden=1
nnoremap fn :NERDTreeFocus<CR>
nnoremap tn :NERDTreeToggle<CR>

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
