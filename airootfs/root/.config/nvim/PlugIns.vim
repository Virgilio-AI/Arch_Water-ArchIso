call plug#begin('~/.config/nvim/PlugIns/')
" for color and personalization
Plug 'rafi/awesome-vim-colorschemes' "ide
Plug 'vim-airline/vim-airline' "personalization for vim
Plug 'vim-airline/vim-airline-themes' "temas
Plug 'ryanoasis/vim-devicons' "vim icons for windows 10
Plug 'frazrepo/vim-rainbow'  " bracket pair colorier
Plug 'junegunn/vim-easy-align' " for easy alignment
" for better motion
Plug 'easymotion/vim-easymotion'  " jump into words using a mapped array of positions


" for debugging
Plug 'puremourning/vimspector' "debugging

" functionalities
Plug 'skywind3000/asyncrun.vim' "for Asyncrinous features
Plug 'preservim/nerdtree'   " file manager for vim
Plug 'junegunn/fzf', { 'do': './install --all' } | Plug 'junegunn/fzf.vim' " fzf for vim, search buffers etc

" git integration
Plug 'tpope/vim-fugitive' " to see diff files

" snippets
Plug 'SirVer/ultisnips' " for snippets
" for latex
Plug 'xuhdev/vim-latex-live-preview' " for latex previews
Plug 'junegunn/vim-peekaboo' " for showing registers before pasting anything
call plug#end() 







