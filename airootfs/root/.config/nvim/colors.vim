
" For normal text

highlight Normal       ctermfg=15  ctermbg=none cterm=none| "For normal text
highlight LineNr       ctermfg=98  ctermbg=235  cterm=bold| "For the left line of numbers
highlight CursorLineNr ctermfg=156 ctermbg=235  cterm=bold| "For the current line number of the left
highlight VertSplit    ctermfg=98  ctermbg=235  cterm=none| " for the line in a vertival split
highlight Statement    ctermfg=79  ctermbg=none cterm=none| " for statements
highlight Directory    ctermfg=21  ctermbg=none cterm=bold| " for Directory color in nerd tree
highlight Special      ctermfg=1  ctermbg=none cterm=bold| " For special characters
highlight Identifier   ctermfg=46  ctermbg=none cterm=bold| " any variable name
		
highlight Comment      ctermfg=166 ctermbg=none cterm=bold
"==========  variable types

highlight String    ctermfg=98  ctermbg=none cterm=italic
highlight Number    ctermfg=1   ctermbg=none cterm=italic
highlight Character ctermfg=14  ctermbg=none cterm=italic
highlight Boolean   ctermfg=154 ctermbg=none cterm=bold
highlight Float     ctermfg=1   ctermbg=none cterm=none
highlight Exception ctermfg=1   ctermbg=none cterm=bold
highlight Repeat    ctermfg=14  ctermbg=none cterm=none
highlight Operator  ctermfg=11  ctermbg=none cterm=bold

" preprocesor
highlight Include   ctermfg=14   ctermbg=none    cterm=italic
highlight Define    ctermfg=14   ctermbg=none    cterm=italic
highlight Macro     ctermfg=14   ctermbg=none    cterm=italic
highlight PreCondit ctermfg=14   ctermbg=none    cterm=italic

" type

highlight StorageClass ctermfg=156 ctermbg=none cterm=none
highlight Structure    ctermfg=156 ctermbg=none cterm=none
highlight Function     ctermfg=14  ctermbg=none cterm=bold


" generic groups

highlight Visual       ctermfg=1     ctermbg=11   cterm=italic
highlight NonText      ctermfg=162   ctermbg=none cterm=bold,italic
highlight SpecialKey   ctermfg=2     ctermbg=none cterm=bold
highlight SpecialChar  ctermfg=2     ctermbg=none cterm=bold
highlight TermCursor   ctermfg=235   ctermbg=11   cterm=none
highlight TermCursorNC ctermfg=235   ctermbg=15   cterm=none
highlight WildMenu     ctermfg=green ctermbg=1    cterm=bold


highlight Cursor       ctermfg=1  ctermbg=none cterm=bold
highlight CursorIM     ctermfg=1  ctermbg=none cterm=bold
highlight CursorColumn ctermfg=none ctermbg=none cterm=italic
highlight DiffAdd      ctermfg=1  ctermbg=none cterm=bold
highlight DiffDelete   ctermfg=84 ctermbg=none cterm=bold
highlight DiffText     ctermfg=11 ctermbg=none cterm=bold







let g:fzf_colors = { 'fg':      ['fg', 'Normal'], 'bg':      ['bg', 'Normal'], 'hl':      ['fg', 'Comment'], 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'], 'bg+':     ['bg', 'CursorLine', 'CursorColumn'], 'hl+':     ['fg', 'Statement'], 'info':    ['fg', 'PreProc'], 'border':  ['fg', 'Ignore'], 'prompt':  ['fg', 'Conditional'], 'pointer': ['fg', 'Exception'], 'marker':  ['fg', 'Keyword'], 'spinner': ['fg', 'Label'], 'header':  ['fg', 'Comment'] }
highlight String    ctermfg=98  ctermbg=none cterm=italic
highlight Number    ctermfg=1   ctermbg=none cterm=italic
highlight Character ctermfg=14  ctermbg=none cterm=italic
highlight Boolean   ctermfg=154 ctermbg=none cterm=bold
highlight Float     ctermfg=1   ctermbg=none cterm=none
highlight Exception ctermfg=1   ctermbg=none cterm=bold
highlight Repeat    ctermfg=14  ctermbg=none cterm=none
highlight Operator  ctermfg=11  ctermbg=none cterm=bold

" preprocesor
highlight Include   ctermfg=14   ctermbg=none    cterm=italic
highlight Define    ctermfg=14   ctermbg=none    cterm=italic
highlight Macro     ctermfg=14   ctermbg=none    cterm=italic
highlight PreCondit ctermfg=14   ctermbg=none    cterm=italic

" type

highlight StorageClass ctermfg=156 ctermbg=none cterm=none
highlight Structure    ctermfg=156 ctermbg=none cterm=none
highlight Function     ctermfg=14  ctermbg=none cterm=bold


" generic groups

highlight Visual       ctermfg=1     ctermbg=11   cterm=italic
highlight NonText      ctermfg=162   ctermbg=none cterm=bold,italic
highlight SpecialKey   ctermfg=2     ctermbg=none cterm=bold
highlight SpecialChar  ctermfg=2     ctermbg=none cterm=bold
highlight TermCursor   ctermfg=235   ctermbg=11   cterm=none
highlight TermCursorNC ctermfg=235   ctermbg=15   cterm=none
highlight WildMenu     ctermfg=green ctermbg=1    cterm=bold


highlight Cursor       ctermfg=1  ctermbg=none cterm=bold
highlight CursorIM     ctermfg=1  ctermbg=none cterm=bold
highlight CursorColumn ctermfg=none ctermbg=none cterm=italic
highlight DiffAdd      ctermfg=1  ctermbg=none cterm=bold
highlight DiffDelete   ctermfg=84 ctermbg=none cterm=bold
highlight DiffText     ctermfg=11 ctermbg=none cterm=bold







let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
