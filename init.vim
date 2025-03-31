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
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
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
set scrolloff=999

colorscheme slate

let mapleader = " "
nnoremap <Leader>w :w<CR>    " Save file with <Leader>w
nnoremap <Leader>q :q<CR>    " Quit Vim with <Leader>q
nnoremap <Leader>x :x<CR>    " Save and Quit Vim with <Leader>q
nnoremap <Leader>d :bd<CR>    " Delete current buffer
nnoremap <Leader>n :bn<CR>    " Next buffer
nnoremap <Leader>p :bp<CR>    " Previous buffer
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>
vnoremap <leader>ca :lua vim.lsp.buf.range_code_action()<CR>

imap <expr> <Tab> snippy#can_expand_or_advance() ?
            \ '<Plug>(snippy-expand-or-advance)' : '<Tab>'
imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
xmap <Tab> <Plug>(snippy-cut-text)

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh :Telescope find_files search_dirs={'~'}<CR>
nnoremap <leader>fc :Telescope find_files search_dirs={'~/'} hidden=true<CR>
nnoremap <leader>fd :Telescope find_files search_dirs={'../'}<CR>

"remove search highlight
nnoremap <silent> <Esc> :noh<CR>

"perform format on save
autocmd BufWritePre * lua PreserveCursorPositionAndFormat()

highlight OverLength ctermfg=Red guifg=Red
autocmd BufWinEnter,TextChanged,TextChangedI *
            \ call matchadd('OverLength', '\%81v.*')


lua << EOF
require'nvim-treesitter.configs'.setup{
    highlight={enable=true}, auto_install=true}
vim.lsp.inlay_hint.enable(true)

function PreserveCursorPositionAndFormat()
  local formatters = {
    go = "gofmt",
    py = "black -q -",
    js = "prettier --stdin-filepath %",
    ts = "prettier --stdin-filepath %",
    json = "prettier --stdin-filepath %",
    c = "clang-format",
    cpp = "clang-format",
    java = "clang-format",
    cs = "clang-format",
    php = "php-cs-fixer fix --quiet",
    r = "styler",  -- Needs 'install.packages(\"styler\")' in R
    sql = "sqlformat -r -",
    swift = "swiftformat --stdin",
    pl = "perltidy",
    asm = "asmfmt",
    vb = "vbformat",
    rb = "rubocop --auto-correct --stdin %",
    m = "mlint",  -- MATLAB
    rust = "rustfmt",
    html = "prettier --stdin-filepath %",
    css = "prettier --stdin-filepath %",
    cobol = "cobc -x",
    jl = "julia -e \"using JuliaFormatter; format(\"\"%)\"\"\"",
    kt = "ktlint",
    scala = "scalafmt",
    pro = "gprolog",
    lisp = "clisp",
    lua = "stylua -",
    f90 = "fprettify",
    hs = "ormolu",
    awk = "awk",
    sol = "forge fmt",
    ps1 = "pwsh -Command 'Format-Table'",
    sh = "shfmt",
    clj = "cljstyle pipe",
    curl = "curlfmt",
    erl = "erl_tidy",
    groovy = "groovyfmt",
    icn = "iconfmt",
    ml = "ocamlformat",
    nim = "nimpretty",
    wls = "wlformatter"
  }

  local ext = vim.fn.expand("%:e")  -- Get file extension
  local formatter = formatters[ext]
  if formatter then
    local save_cursor = vim.fn.getpos(".")  -- Save cursor position
    -- Read the buffer content
    local content = table.concat(
        vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
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
