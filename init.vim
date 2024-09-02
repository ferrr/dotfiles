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
set backupdir=~/.cache/vim   " Directory to store backup files
set termguicolors            " better colors
set clipboard+=unnamedplus   " use system clipboard

" Shift-tab to insert tabs
inoremap <S-Tab> <C-V><Tab>

nnoremap <C-t> :NERDTreeToggle<cr>
nnoremap <leader>r :NERDTreeFind<cr>

" pane navigation with CTRL-hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <C-Tab> <cmd>Telescope buffers<cr>

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
" Run PlugInstall if there are missing plugins autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) \| PlugInstall --sync | source $MYVIMRC \| endif

call plug#begin('~/.vim/plugged')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'tpope/vim-sensible'
  Plug 'preservim/nerdtree'
  Plug 'ferrr/vscode.nvim'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'numToStr/Comment.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
  Plug 'github/copilot.vim'
call plug#end()

lua << END
 require('Comment').setup()
 require('vscode').setup({
   transparent = true,
 })
 require('vscode').load()
 require("toggleterm").setup({
   direction = 'float',
   open_mapping = [[<c-\>]],
 })
 require("bufferline").setup{
     options = {
         mode = 'buffers',
         -- diagnostics = 'coc',
         show_buffer_icons = true,
         show_buffer_close_icons = false,
         separator_style = { '│', '│' },
         sort_by = 'insert_at_end',
         offsets = {
             {
                     filetype = "NvimTree",
                     text = "File Explorer",
                     highlight = "Directory",
                     separator = true,
             }
             },
     },
     highlights = {
         buffer_selected = {
             bold = true,
             italic = false,
         },
         buffer_visible = { fg = "gray" },
         background = { fg = "gray" },
     },
 }
 require('lualine').setup {
   options = {
       theme = 'vscode',
       icons_enabled = false,
       component_separators = '│',
       section_separators = '',
   },
 }
 require('gitsigns').setup {
     current_line_blame = true,
 }

 -- Keymaps
local opts = { noremap = true, silent = true, desc = 'Go to Buffer' }
-- vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
-- vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
vim.keymap.set('n', '<leader>1', "<cmd>lua require('bufferline').go_to_buffer(1)<CR>", opts)
vim.keymap.set('n', '<leader>2', "<cmd>lua require('bufferline').go_to_buffer(2)<CR>", opts)
vim.keymap.set('n', '<leader>3', "<cmd>lua require('bufferline').go_to_buffer(3)<CR>", opts)
vim.keymap.set('n', '<leader>4', "<cmd>lua require('bufferline').go_to_buffer(4)<CR>", opts)
vim.keymap.set('n', '<leader>5', "<cmd>lua require('bufferline').go_to_buffer(5)<CR>", opts)
vim.keymap.set('n', '<leader>6', "<cmd>lua require('bufferline').go_to_buffer(6)<CR>", opts)
vim.keymap.set('n', '<leader>7', "<cmd>lua require('bufferline').go_to_buffer(7)<CR>", opts)
vim.keymap.set('n', '<leader>8', "<cmd>lua require('bufferline').go_to_buffer(8)<CR>", opts)
vim.keymap.set('n', '<leader>9', "<cmd>lua require('bufferline').go_to_buffer(9)<CR>", opts)
END
