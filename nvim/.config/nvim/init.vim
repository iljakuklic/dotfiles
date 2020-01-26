" Initialise plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
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
set completeopt+=preview
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 0

" Sign column style
set signcolumn=yes
au ColorScheme * highlight clear SignColumn
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
highlight clear LspWarningLine

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

" Setup LSP with bash-language-server
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

" Setup LSP with Haskell ghcide
if executable('ghcide')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'ghcide',
      \ 'cmd': {server_info->['ghcide', '--lsp']},
      \ 'whitelist': ['haskell'],
      \ })
endif

" Ctrl-L to clear search highlight
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
" ]w ]W [w [W to move around windows in normal mode
nnoremap ]w <C-W>w
nnoremap [w <C-W>W
nnoremap [W <C-W>t
nnoremap ]W <C-W>b
" Don't block switching from hidden buffers
set hidden
