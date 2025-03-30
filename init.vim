call plug#begin()
    Plug 'vim-airline/vim-airline' "information display at bottom
    Plug 'tpope/vim-commentary' "comment code with gcc and gc
    Plug 'dcampos/nvim-snippy' "for adding snippets
    Plug 'dcampos/cmp-snippy' "for adding snippets in autocompletion
    Plug 'neovim/nvim-lspconfig' "to integrate with nvim-lsp
    Plug 'hrsh7th/cmp-nvim-lsp' "to add autocompletion from lsp
    Plug 'hrsh7th/cmp-buffer' "to add autocompletion from words in buffer
    Plug 'hrsh7th/cmp-path' "to add autocompletion from paths
    Plug 'hrsh7th/cmp-cmdline' "to add autocompletion for terminal commands
    Plug 'hrsh7th/nvim-cmp' "for general autocompletion
    Plug 'itmammoth/doorboy.vim' "for auto-close brackets and quotes
    Plug 'Exafunction/codeium.vim', { 'branch': 'main' } "ai code suggestion
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

"perform format on save
autocmd BufWritePre *.go lua PreserveCursorPositionAndFormat()

lua << EOF
function PreserveCursorPositionAndFormat()
  local formatters = {
    go = "gofmt",
    py = "black -q -",  -- Black autoformatter for Python
    js = "prettier --stdin-filepath %",
    ts = "prettier --stdin-filepath %",
    json = "prettier --stdin-filepath %"
  }

  local ext = vim.fn.expand("%:e")  -- Get file extension
  local formatter = formatters[ext]

  if formatter then
    local save_cursor = vim.fn.getpos(".")  -- Save cursor position

    -- Read the buffer content
    local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")

    -- Run the formatter
    local result = vim.fn.system(formatter, content)

    -- If formatting was successful, update the buffer
    if vim.v.shell_error == 0 then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
    else
      print("Formatting error: " .. result)
    end

    vim.fn.setpos(".", save_cursor)  -- Restore cursor position
  end
end



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
    { name = 'path' },
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
