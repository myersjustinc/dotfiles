" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Add required settings for Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Add enhanced tab completion
set wildmenu

" Show commands in progress as they're being typed
set showcmd

" Make backspace behave in a sane manner
set backspace=indent,eol,start

" Show line numbers
set number

" Allow hidden buffers, don't limit to 1 file per window/split
set hidden

" Increase stored command history
set history=100

" Set color scheme
colorscheme desert

" Set font for MacVim
set guifont=Source_Code_Pro:h22

" Default to Unicode
set encoding=utf-8

" Handle Mac file endings properly
set ffs=unix,mac,dos

" Reload externally changed files
set autoread

" Find matches while we search
set incsearch

" Highlight search matches
set hlsearch

" Set indent options
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent

" Set folding options
set foldmethod=indent
set foldnestmax=6

" Disable word wrap
set nowrap

" Add position indicator to bottom right
set ruler

" Set text width to my preference
set textwidth=79

" Set scrolling margins
set scrolloff=5
set sidescrolloff=5
set sidescroll=1

" Disable swap files
set noswapfile
set nobackup
set nowb

" Make splits open in more natural directions
set splitbelow
set splitright

" Specify plugins
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Bundle 'groenewege/vim-less'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'jmcantrell/vim-virtualenv'

" Configure airline
set laststatus=2
let g:airline#extensions#whitespace#enabled=0

" Add vim-less requirement
nnoremap <Leader>m :w <BAR> !lessc % > %:t:r.css<CR><space>

" Add vim-markdown config
let g:vim_markdown_folding_disabled=1

" Finish Vundle initialization
call vundle#end()

" Enable file type detection and do language-dependent indenting
filetype plugin indent on
autocmd Filetype python setlocal shiftwidth=4 softtabstop=4
autocmd Filetype markdown setlocal shiftwidth=4 softtabstop=4

" Configure solarized
syntax on
set background=dark
colorscheme desert

" Mark the 80th column in the window for PEP 8 purposes
set colorcolumn=79
highlight ColorColumn ctermbg=gray guibg=PaleTurquoise4

" Mark the line currently being edited
set cursorline
highlight CursorLine ctermbg=Black guibg=Black

" Change fugitive's gutter colors
highlight SignColumn guibg=DarkSlateGray
highlight GitGutterAdd guibg=DarkSlateGray guifg=SeaGreen2
highlight GitGutterDelete guibg=DarkSlateGray guifg=firebrick3
highlight GitGutterChange guibg=DarkSlateGray guifg=DodgerBlue1

" Always cd to current file's directory
" Apparently conflicts with some plugins, so watch out
set autochdir
