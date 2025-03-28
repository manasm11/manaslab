call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'tpope/vim-commentary'
    Plug 'dcampos/nvim-snippy'
    Plug 'dcampos/cmp-snippy'
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'itmammoth/doorboy.vim'
call plug#end()

set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=a
set expandtab
set completeopt=menuone,longest
set shortmess+=c
set spell
set spelloptions=camel

colorscheme slate

imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<Tab>'
imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
xmap <Tab> <Plug>(snippy-cut-text)

lua << EOF
require("lspconfig").gopls.setup({})
vim.diagnostic.config({
    virtual_text = true, -- Show error messages inline
    signs = true,        -- Show signs in the gutter
    underline = true,    -- Underline errors
    update_in_insert = false,
    severity_sort = true,
})
vim.o.updatetime = 250  -- Reduce update time for better responsiveness

vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = "cursor" })
    end,
})



local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'snippy' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' }
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true })
  })
})
EOF
