set nocompatible             " disable compatibility to old-time vi
set showmatch                " show matching 
set ignorecase               " case insensitive 
set mouse=v                  " middle-click paste with 
set hlsearch                 " highlight search 
set incsearch                " incremental search
set tabstop=4                " number of columns occupied by a tab 
set softtabstop=4            " see multiple spaces as tabstops so <BS> does the right thing
set expandtab                " converts tabs to white space
set shiftwidth=4             " width for autoindents
set autoindent               " indent a new line the same amount as the line just typed
filetype plugin indent on    " allow auto-indenting depending on file type
syntax on                    " syntax highlighting
set mouse=a                  " enable mouse click
set clipboard=unnamedplus    " using system clipboard
filetype plugin on
set ttyfast                  " Speed up scrolling in Vim
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set noswapfile               " disable creating swap file
set backupdir=~/.cache/vim   " Directory to store backup files.
set termguicolors            " better colors 

" Shift-tab to insert tabs
inoremap <S-Tab> <C-V><Tab>

if exists("$TMUX")
    " try to fix background autodetection under tmux
    " https://github.com/neovim/neovim/issues/17070#issuecomment-1086775760
    lua vim.loop.fs_write(2, "\27Ptmux;\27\27]11;?\7\27\\", -1, nil)
endif

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-sensible'
  Plug 'preservim/nerdtree'
  Plug 'ferrr/vscode.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'numToStr/Comment.nvim'
call plug#end()

lua << END
 require('Comment').setup()
 require('vscode').setup({
   transparent = true,
 })
 require('vscode').load()

 require('lualine').setup {
   options = {
       theme = 'vscode',
   }
 }
END
