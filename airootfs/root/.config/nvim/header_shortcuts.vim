" ==================================================
" =========== vimrc ===================
" ==================================================
augroup BufferVariables
"au BufEnter * let b:FilePathNoExtension = expand("%:e") file name no

au BufEnter * let b:FilePathNoExtension = expand("%:r") " path/main
au BufEnter * let b:Extension = expand("%:e") " tex
au BufEnter * let b:FileName = expand("%:t") " main.tex
au BufEnter * let b:FilePath = expand("%") " path/main.tex
au BufEnter * let b:FileNameNoExtension = expand("%:t:r") " main
au BufEnter * let b:CurrentFolder = expand("%:p:h") "pathFolder/folder
augroup end


function! OpenVimrcHeaderRelatedFile()
	let l:name = b:CurrentFolder . "/header_" . b:FileName 
	exe ":split" . l:name
endfunction

" ----------- endvimrc -------------------
"
"
" ==================================================
" =========== For editing beter ===================
" ==================================================
function! SetAbsoluteNumber()
	:set rnu! 
	:set nu
endfunction
function! SetRelativeNumber()
	:set nu
	:set rnu
endfunction

"maximize windows

function! Maximize()
	let l:Line = line(".")
	let l:Column = col(".")
	:tabnew %
	exe "call cursor(" . l:Line . "," . l:Column . ")"
endfunction

function! Minimize()
	let l:Line = line(".")
	let l:Column = col(".")
	:tabclose
	exe "call cursor(" . l:Line . "," . l:Column . ")"
endfunction



" ----------- end For editing beter -------------------
" ==================================================
" =========== Git Commands ===================
" ==================================================
function! LazyGit()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "lazygit"
endfunction
function! GitAddAll()
	:AsyncRun git add .
endfunction
function! GitAddFile()
	:AsyncRun git add %:p
endfunction

function! GitCommit()
	call inputsave()
	let l:commit_message = input('enter commit message: ')
	call inputrestore()
	let l:command = "git commit -m \"" . l:commit_message ."\" ; read -n1"
	:echo l:command
	execute ":AsyncRun st -T \"floating\" -g \"=150x50+250+100\" -e sh -c \"" . l:command . "\""
endfunction

function! GitPushMaster()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "git push origin master"
endfunction

function! GitPushMasterForce()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "git push -f origin master"
endfunction! 

function! GitAddCommitPush()
	:call GitAddAll()
	:sleep 2
	:call GitCommit()
	redraw
	sleep 10
	:call GitPushMaster()
endfunction

function! GitAddCommitPushForce()
	:call GitAddFiles()
	:sleep 2
	:call GitCommit()
	:sleep 10
	redraw
	:call GitPushMasterForce()
endfunction

function! GitStatus()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "git status ; read -n1"
endfunction
function! GitLogOneLine()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "git log --oneline"
endfunction
function! GitLog()
	:AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "git log "
endfunction

" ----------- end Git Commands -------------------



" ==================================================
" =========== Compile and run various code ===================
" ==================================================
" compile and run in c++
function! CompileAndRunCpp(RunCommand)
:w!
exe ':AsyncRun st -T "floating" -e sh -c "' . a:RunCommand . ' %:p -o %< && ./%< ; read -n1"'
endfunction
"compile and run latex
function! CompileAndRunLatex()
	:w!
	let l:PdfFile = b:FileNameNoExtension . ".pdf"
	exe 'AsyncRun st -T "floating" -g "=80x45+600+80" -e sh -c "cd %:p:h && pdflatex --shell-escape ' . b:FileName .  '"'
	sleep 4
	exe 'AsyncRun st -T "floating" -g "=80x45+600+80" -e sh -c "cd %:p:h && zathura ' . l:PdfFile . '"'
endfunction

" ----------- end Compile and run various code -------------------


" ==================================================
" =========== File operations ===================
" ==================================================
function! GivePermissions()
	exe ":AsyncRun st -e sh -c \"sudo chmod 777 %:p ; sudo chown " . g:USER . " %:p ; sudo chgrp " . g:GROUP . " %:p \" "
endfunction

" ----------- end File operations -------------------
