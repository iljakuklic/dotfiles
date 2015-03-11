" Unite settings
call unite#custom#profile('default', 'context', {
			\	'vertical': 1,
			\	'winwidth': 50
			\ })

" Unite key mappings
nnoremap <C-U><C-U> :Unite -toggle<CR>
nnoremap <C-U>f :Unite -start-insert file_rec<CR>
nnoremap <C-U>b :Unite -start-insert buffer window tab<CR>
nnoremap <C-U>g :Unite -start-insert grep<CR>

" settings inside the Unite buffer
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	imap <buffer> <Tab> <Plug>(unite_select_next_line)
	imap <buffer> <C-O> <Plug>(unite_choose_action)
	nmap <buffer> <C-Z> <Plug>(unite_toggle_transpose_window)
	imap <buffer> <C-Z> <Plug>(unite_toggle_transpose_window)
	imap <silent><buffer><expr> <C-S> unite#do_action('split')
endfunction
