" =================================
" ========== autocommands section 
" =================================

" sudo make 
function! Make()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo make ; sh -c read -n1"
endfunction

" sudo make install
function! MakeInstall()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo make ; sudo make install ; sh -c read -n1 "
endfunction

" sudo make ; sudo make install 
function! MakeMakeInstall()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo make ; sudo make install ; sh -c read -n1 "
endfunction

" cp config.def.h config.h ; sudo make clean install 
function! MakeCleanInstallSuckless()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo cp config.def.h config.h ; sudo make clean install ; sh -c read -n1"
endfunction

" sudo make clean install
function! MakeCleanInstall()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo make clean install ; sh -c read -n1"
endfunction

" dwmblocks
function! DwmblocksInstall()
	:AsyncRun st -T "floating" -g '=150x50+250+100' -e sh -c "sudo cp blocks.def.h blocks.h ; sudo make install && { killall -q dwmblocks;setsid dwmblocks & } ; read -n1 "
endfunction


function! CentreCursor()
    let pos = getpos(".")
    normal! zz
    call setpos(".", pos)
endfunction


