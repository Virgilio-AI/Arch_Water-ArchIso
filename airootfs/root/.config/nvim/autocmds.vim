" =================================
" ========== when cursor moved 
" =================================
augroup onCursorMoved
	autocmd!
	autocmd CursorMoved,CursorMovedI * call CentreCursor()
augroup END
" =================================
" ========== Latex 
" =================================

augroup onEnter
	autocmd!
	au FileType .tex call rainbow#load()
augroup END

" =================================
" ========== vimrc
" =================================


augroup saveChanges
	autocmd!
	exec 'autocmd BufWritePre ' . g:CONFIG_PATH . '/* :so $MYVIMRC'
augroup END
" =================================
" ========== dwm 
" =================================


augroup install_dwm
	autocmd!
	exec 'autocmd BufWritePre ' . g:SRC_PATH . '/dwm/* call MakeCleanInstallSuckless()'
augroup END

augroup install_dwmblocks
	autocmd!
	exec 'autocmd BufWritePre ' . g:SRC_PATH . '/dwmblocks/* call DwmblocksInstall() '
augroup END

augroup install_st
	autocmd!
	exec 'autocmd BufWritePre ' . g:SRC_PATH . '/st/* call MakeCleanInstallSuckless()'
augroup END

augroup install_dmenu
	autocmd!
	exec 'autocmd BufWritePre ' . g:SRC_PATH . '/dmenu/* call MakeCleanInstallSuckless()'
augroup END

augroup install_cfiles
	autocmd!
	exec 'autocmd BufWritePre ' . g:SRC_PATH . '/cfiles/* call MakeMakeInstall()'
augroup END



" =================================
" ========== One Vim Plug Startup 
" =================================
autocmd VimEnter *
  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall | q
  \| endif
" =================================
" ========== For competitive programing 
" =================================
