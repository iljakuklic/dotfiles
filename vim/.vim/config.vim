" terminal settings
set t_Co=256
set term=xterm-256color
set lazyredraw
set backspace=indent,eol,start

" encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" regional settings
set spelllang=en_gb

" tab sizes
set shiftwidth=4
set tabstop=4
set softtabstop=4

" search
set hlsearch
set smartcase
set ignorecase

" user interface
set number
set scrolloff=3
set wildmenu
set wildignore=*.o,*~,*.pyc

" YouCompleteMe
set completeopt-=preview
let g:ycm_confirm_extra_conf=0
