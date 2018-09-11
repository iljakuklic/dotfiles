" Initialise plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
call plug#end()

" Ctrl-L to clear search highlight
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
