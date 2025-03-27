call plug#begin()
    Plug 'vim-airline/vim-airline'
    Plug 'tpope/vim-commentary'
    Plug 'vim-scripts/AutoComplPop'
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

colorscheme slate

" Abbreviations format: autocmd FileType [filetyp] iabbrev <buffer> [shortcut] [expansion]
autocmd FileType go iabbrev <buffer> pmain package main<CR>
autocmd FileType go iabbrev <buffer> impo import (<CR>)
autocmd FileType go iabbrev <buffer> tea tea "github.com/charmbracelet/bubbletea"
