" Initialise plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ajh17/vimcompletesme'
Plug 'Superbil/llvm.vim'
call plug#end()

" Some colours
colorscheme slate
highlight Search ctermfg=None ctermbg=DarkGrey

" Auto-completion & IDE-like features settings
set completeopt-=preview
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:lsp_signs_enabled = 1
"let g:lsp_diagnostics_echo_cursor = 1

" Sign column style
set signcolumn=yes
highlight clear SignColumn
set number
" LSP-specific stuff for  sign column
let g:lsp_signs_error = {'text': '■'}
let g:lsp_signs_warning = {'text': '□'}
let g:lsp_signs_information = {'text': '▹'}
let g:lsp_signs_hint = {'text': '▸'}
highlight link LspErrorText LineNr
highlight link LspWarningText LineNr
highlight link LspInformationText LineNr
highlight link LspHintText LineNr

" Setup LSP with clangd
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
    augroup end
endif

" Ctrl-L to clear search highlight
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
