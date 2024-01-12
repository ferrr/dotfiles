set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set ttyfast                 " Speed up scrolling in Vim
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set noswapfile              " disable creating swap file
set backupdir=~/.cache/vim  " Directory to store backup files.

call plug#begin('~/.vim/plugged')
 Plug 'tpope/vim-sensible'
 Plug 'vimpostor/vim-lumen'
 Plug 'preservim/nerdtree'
 Plug 'Mofiqul/vscode.nvim'
 Plug 'nvim-lualine/lualine.nvim'
 Plug 'numToStr/Comment.nvim'
" Plug 'shaunsingh/solarized.nvim'
" Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
call plug#end()

"au User LumenLight echom 'Entered light mode'
"au User LumenDark echom 'Entered dark mode'

lua << END
require('Comment').setup()
local c = require('vscode.colors').get_colors()
require('vscode').setup({
    transparent = true,
})
require('vscode').load()
require('lualine').setup({
    options = {
        theme = 'vscode'
    },
})
END

"colorscheme delek
