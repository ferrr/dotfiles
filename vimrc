syntax on

set t_Co=256
colors delek

" set number
hi LineNr ctermfg=darkgray ctermbg=gray

hi StatusLine ctermfg=white ctermbg=darkgray

set nocompatible
set virtualedit=all                                               " allows the cursor to stray beyond defined text

au StdinReadPost * :set nomodified                                " use :q from stdin

set nobackup                                                      " don't write backup files
set noswapfile

set backspace=2
set statusline=%t\ %y\ format:\ %{&ff};\ [%c,%l]
set laststatus=2
set pastetoggle=<F2>
set hlsearch
set hl=l:Visual                                                   " use Visual mode's highlighting scheme --much better
set incsearch

set cmdheight=1                                                   " explicitly set the height of the command line
set showcmd                                                       " Show (partial) command in status line.
set ruler                                                         " show current position at bottom
set noerrorbells                                                  " don't whine
set visualbell t_vb=                                              " and don't make faces
set lazyredraw                                                    " don't redraw while in macros
set scrolloff=5                                                   " keep at least 5 lines around the cursor
set wrap                                                          " soft wrap long lines
set list                                                          " show invisible characters
set listchars=tab:>·,trail:·                                      " but only show tabs and trailing whitespace
set report=0                                                      " report back on all changes
set shortmess=atI                                                 " shorten messages and don't show intro
set wildmenu                                                      " turn on wild menu :e <Tab>
set wildmode=list:longest                                         " set wildmenu to list choice

"------ Indents and tabs ------"
set autoindent                                                   " set the cursor at same indent as line above
set smartindent                                                  " try to be smart about indenting (C-style)
set expandtab                                                    " expand <Tab>s with spaces; death to tabs!
set shiftwidth=4                                                 " spaces for each step of (auto)indent
set softtabstop=4                                                " set virtual tab stop (compat for 8-wide tabs)
set tabstop=4                                                    " for proper display of files with tabs
set ttyfast
"set shiftround                                                  " always round indents to multiple of shiftwidth
" set copyindent                                                   " use existing indents for new indents
" set preserveindent                                               " save as much indent structure as possible
filetype plugin indent on                                        " load filetype plugins and indent settings


"------ Key remapping ---------"
" Remap <C-space> to word completion
noremap! <Nul> <C-n>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

call pathogen#infect()                                            " easy install plugins

" disable arrow keys
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

if has("gui_macvim")
    set gfn=Consolas:h12
    colors molokai
    set transparency=5
    set nonu
    "set fu
    set guioptions-=T
    set guioptions-=m
    set guioptions-=l
    set guioptions-=r
    set guioptions-=b
    set guioptions-=t
    set go-=L
    noremap <M-Enter> :set invfullscreen<CR>
    set columns=130
    set lines=40

    " switch to russian layout F12
    set keymap=russian-jcukenwin
    set iminsert=0
    imap <F12> 
    cmap <F12> 
endif

