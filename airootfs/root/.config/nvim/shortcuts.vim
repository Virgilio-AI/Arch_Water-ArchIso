" =================================
" ========== Shortcuts file 
" =================================

" open file manager
exec 'nnoremap <F6>3 :AsyncRun st -T "floating" -g "=150x50+250+100" -e sh -c "cfiles" '
" toggle side file manager nerdtree
nnoremap <C-b> :NERDTreeToggle<CR>
inoremap <C-b> <Esc>:NERDTreeToggle<CR>
" open terminal
exe 'nnoremap <F6>0 :AsyncRun sh -c "cd %:p:h ; st -T "floating" -g "=80x45+600+80"" '

" ==================================================
" =========== vimrc ===================
" ==================================================

nnoremap <leader>ev :vsplit $MYVIMRC<CR>
exe "nnoremap <leader>evs :vsplit " . g:CONFIG_PATH . '/shortcuts.vim'  
exe "nnoremap <leader>eva :vsplit " . g:CONFIG_PATH . '/autocmds.vim'  
exe "nnoremap <leader>evp :vsplit " . g:CONFIG_PATH . '/PlugIns.vim'
exe "nnoremap <leader>evc :vsplit " . g:CONFIG_PATH . '/colors.vim'
exe "nnoremap <leader>evh :call OpenVimrcHeaderRelatedFile()" 


" ==================================================
" =========== For editing better ===================
" ================================================== 

" for copy paste
nnoremap -y "+y
vnoremap -y "+y

nnoremap -p "+p
vnoremap -p "+p


" change surroundings
noremap <leader>[ a[<Esc>h%xi]<Esc>%hx
noremap <leader>] a]<Esc>h%xi[<Esc>%hx
noremap <leader>( a(<Esc>h%xi)<Esc>%hx
noremap <leader>) a)<Esc>h%xi(<Esc>%hx
noremap <leader>{ a{<Esc>h%xi}<Esc>%hx
noremap <leader>} a}<Esc>h%xi{<Esc>%hx
"min and maximize windows
nnoremap <leader>hp :vertical resize +30<CR>
nnoremap <leader>hm :vertical resize -30<CR>
nnoremap <leader>vp :res +30<CR>
nnoremap <leader>vm :res -30<CR>
"vim like movements
imap <C-Del> X<Esc>lbce
inoremap <C-BS> <C-w>
inoremap <C-u> <Nop>
nnoremap <C-BS> <C-w>
"maximize windows
noremap -- :call Minimize()<CR>
nnoremap -= :call Maximize()<CR>
" select all
nnoremap -a ggVG
"set number and set relative number

nnoremap -n :call SetAbsoluteNumber()<CR>
nnoremap -r :call SetRelativeNumber()<CR>
" ---------- and For editing better ----------------

" ==================================================
" =========== Git commands ===================
" ==================================================
nnoremap <leader>gg  :call GitAddCommitPush()
nnoremap <leader>ggf :call GitAddCommitPushForce()
nnoremap <leader>gc  :call GitCommit()
nnoremap <leader>gs  :call GitStatus()
nnoremap <leader>gaa :call GitAddAll()
nnoremap <leader>gaf :call GitAddFile()
nnoremap <leader>lg  :call LazyGit()
nnoremap <leader>lp  :call GitPushMaster()
nnoremap <leader>gd  :Git diff
nnoremap <leader>gdh :Gdiffsplit
nnoremap <leader>gdv :Gvdiffsplit
nnoremap <leader>gvv :Gdiffsplit<CR>l
nnoremap <leader>ghh :Gdiffsplit<CR><Esc>l-ay:q!<CR>:split temp<CR>p
nnoremap <leader>gp  :call GitPushMaster()
nnoremap <leader>gpf :call GitPushMasterForce()
nnoremap <leader>glo :call GitLogOneLine()
nnoremap <leader>gl  :call GitLog()

" ----------- end Git commands -------------------

" ==================================================
" =========== File Operations ==========================
" ==================================================

augroup file_operations
execute 'autocmd FileType * nnoremap -fp :call GivePermissions()' 
execute 'autocmd FileType * inoremap -fp :call GivePermissions()'
augroup end

" ----------- end file operations -------------------



" ==================================================
" =========== compile and run code =================
" ==================================================
"function to compile and run a cpp file given any sircunstance


"compile and run code in nvim
augroup Run_cpp
execute 'autocmd FileType cpp nnoremap <F11> :call CompileAndRunCpp("g++")<CR>' 
execute 'autocmd FileType cpp inoremap <F11> <Esc>:call CompileAndRunCpp("g++")<CR>'
augroup end

augroup Run_gcc
execute 'autocmd FileType c nnoremap <F11> :call CompileAndRunCpp("gcc")<CR>' 
execute 'autocmd FileType c inoremap <F11> <Esc>:call CompileAndRunCpp("gcc")<CR>'
augroup end


augroup Run_Tex
execute 'autocmd FileType tex nnoremap <F10> <Esc>:call CompileAndRunLatex()'
execute 'autocmd FileType tex nnoremap <F11> <Esc>:w<CR>:LLPStartPreview'
execute 'autocmd FileType tex inoremap <F11> <Esc>:w<CR>:LLPStartPreview'
augroup end
" ------------------ End compile and run code -------------------------
"
"
" ==================================================
" =========== Plug ins key bindings ===================
" ==================================================
"fzf find commands
nnoremap <leader>sp :Files 
execute 'nnoremap <leader>sp :Files %:p:h<CR>'
execute 'nnoremap <leader>sp1 :Files %:p:h:h<CR>'
execute 'nnoremap <leader>sp2 :Files %:p:h:h:h<CR>'
nnoremap <leader>sg :GFiles
nnoremap <leader>sg? :GFiles?
nnoremap <leader>sb :Buffers
nnoremap <leader>sl :Lines
nnoremap <leader>slb :BLines
nnoremap <leader>st :Tags
nnoremap <leader>stb :BTags
nnoremap <leader>sni :Snippets
nnoremap <leader>sc :Commits
nnoremap <leader>scb :BCommits
nnoremap <leader>sm :Maps
nnoremap <leader>sh :History
nnoremap <leader>shc :History/


"vim easy motion map
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"vimspector commands
nnoremap <leader>df :call vimspector#Launch()<CR>
nnoremap <leader>dr :call vimspector#Reset()<CR>
nnoremap <leader>dc :call vimspector#Continue()<CR>
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dx :call vimspector#ClearBreakpoints()<CR>

"ulti snips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsEditSplit="vertical"
noremap <leader>es :UltiSnipsEdit


"nerd tree bindings
let NERDTreeMapChangeRoot ='l'
let NERDTreeMapUpdir = 'h'
nnoremap -b :NERDTreeFind<CR>

" ========================Easy allign commands
" " Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ----------- end Plug ins key bindings -------------------
