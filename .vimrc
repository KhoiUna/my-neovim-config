" Add numbers to each line on the left-hand side.
set relativenumber

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

" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Find files plugin - Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }

call plug#end()
" }}}

" KEYS MAPPINGS ------------------------------------------------------- {{{
nnoremap <leader>t :belowright term<CR> 

" Config NERDTree
let NERDTreeShowHidden=1
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Config Telescope - Find files using Telescope command-line sugar.
noremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Use TAB to autocomplete
inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"
inoremap <silent><expr> <cr> "\<c-g>u\<CR>"
" }}}

