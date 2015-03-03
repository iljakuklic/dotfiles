" enable neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#auto_completion_start_length = 3
let g:neocomplete#sources#syntax#min_keyword_length = 4
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#enable_cursor_hold_i = 1

" key bindings
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()
inoremap <silent> <CR>   <C-r>=<SID>my_cr_function()<CR>
inoremap <expr><TAB>     pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><BS>      neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>     neocomplete#close_popup()
inoremap <expr><C-e>     neocomplete#cancel_popup()

function! s:my_cr_function()
	return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

" various filetypes
autocmd FileType html,xml setlocal omnifunc=htmlcomplete#CompleteTags

" omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
