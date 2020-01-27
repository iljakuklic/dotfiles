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
Plug 'sjl/gundo.vim'
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
let g:lsp_virtual_text_prefix = " ⮜ "
"let g:lsp_highlight_references_enabled = 1

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

" Language server protocol setup
augroup vimrc_lsp_init

  " Special settings for LSP-enabled buffers
  function! s:on_lsp_buffer_enabled() abort
    " LSP actions
    nmap <buffer> K     <Plug>(lsp-hover)
    nmap <buffer> <F3>h <Plug>(lsp-hover)
    nmap <buffer> <F3>s <Plug>(lsp-signature-help)
    nmap <buffer> <F3>r <Plug>(lsp-references)
    nmap <buffer> <F3>R <Plug>(lsp-rename)
    "nmap <buffer> <F3>a <Plug>(lsp-code-action)
    nmap <buffer> <F3>a :LspCodeAction<CR>
    nmap <buffer> <F3>d <Plug>(lsp-peek-declaration)
    nmap <buffer> <F3>D <Plug>(lsp-declaration)
    nmap <buffer> <F3>f <Plug>(lsp-peek-definition)
    nmap <buffer> <F3>F <Plug>(lsp-definition)
    nmap <buffer> <F3>i <Plug>(lsp-peek-implementation)
    nmap <buffer> <F3>I <Plug>(lsp-implementation)
    nmap <buffer> <F3>t <Plug>(lsp-peek-type-definition)
    nmap <buffer> <F3>T <Plug>(lsp-type-definition)
    nmap <buffer> <F3>y <Plug>(lsp-type-hierarchy)
    nmap <buffer> <F3>n <Plug>(lsp-workspace-symbol)
    nmap <buffer> <F3>N <Plug>(lsp-document-symbol)
    nmap <buffer> <F3>g <Plug>(lsp-document-diagnostics)
    nmap <buffer> <F3>= <Plug>(lsp-document-format)
    nmap <buffer> <F3>q <Plug>(lsp-preview-close)

    " Diagnostics navigation
    nmap <buffer> [k <Plug>(lsp-previous-error)
    nmap <buffer> ]k <Plug>(lsp-next-error)
    nmap <buffer> [K <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]K <Plug>(lsp-next-diagnostic)
    nmap <buffer> [r <Plug>(lsp-previous-reference)
    nmap <buffer> ]r <Plug>(lsp-next-reference)

    " Formatting
    xmap <buffer> = <Plug>(lsp-document-range-format)
    nmap <buffer> = <Plug>(lsp-document-range-format)

    " A couple of command shortcuts
    command Symbol :LspWorkspaceSymbol
    command Symbols :LspDocumentSymbol
    command Diagnostics :LspDocumentDiagnostics
  endfunction

  au!
  au User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

  " Setup LSP with clangd
  if executable('clangd')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd']},
          \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
          \ })
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

augroup end

" Ctrl-L to clear search highlight
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
" ]w ]W [w [W to move around windows in normal mode
nnoremap ]w <C-W>w
nnoremap [w <C-W>W
nnoremap [W <C-W>t
nnoremap ]W <C-W>b
" Faster preview window manipulation
noremap <C-J> <C-W>z
" Toggle undo window
nnoremap <F3>u :GundoToggle<CR>

" Don't block switching from hidden buffers
set hidden
