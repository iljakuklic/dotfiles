" === TAB completion

" enable neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#auto_completion_start_length = 3
let g:neocomplete#sources#syntax#min_keyword_length = 4
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_cursor_hold_i = 1

" various filetypes
autocmd FileType html,xml setlocal omnifunc=htmlcomplete#CompleteTags

" omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" === Snippets

if has('conceal')
  " hide snippet markers (disabled for now, does not work in select mode?)
  "set conceallevel=2 concealcursor=i
endif

" === Key bindings

inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<TAB>"
imap     <expr><CR>  pumvisible() && neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" :
				   \ "\<Return>"
inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"

" Ctrl-k for snippet expansion and insertion point jumping
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
