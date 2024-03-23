set encoding=utf8
set relativenumber
set number
set autoread
set linebreak
set lazyredraw

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

runtime macros/matchit.vim

" PLUGINS ---------------------------------------------------------------- {{{
call plug#begin('~/.vim/plugged')

" Treesitter highlighting
Plug 'nvim-treesitter/nvim-treesitter'

" LSP support & autocomplete
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

" Theme
Plug 'morhetz/gruvbox'

" Go formatter
Plug 'ray-x/go.nvim'

" GUI library for Neovim plugin developers
"Plug 'ray-x/guihua.lua'

" Terminal emulator
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

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
" Show Tab window dialog 
noremap <leader><C-i> :W<CR>

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

" END KEYMAPPINGS }}}

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

-- Set up nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
		require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- LSP setup
require'lspconfig'.ruby_ls.setup{}
require'lspconfig'.tsserver.setup{}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
