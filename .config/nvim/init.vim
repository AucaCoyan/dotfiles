" A bare minimal init.vim
" syntax on
set relativenumber
set number

call plug#begin()
Plug 'Rigellute/shades-of-purple.vim'           " based on shades-of-purple-vscode
Plug 'xiyaowong/nvim-transparent'               " make the background transparent
Plug 'yuttie/comfortable-motion.vim'            " smooth scrolling
Plug 'vim-airline/vim-airline'                  " Vim Status line
Plug 'vim-airline/vim-airline-themes'           " And its themes
Plug 'dag/vim-fish'				" Fish syntax highligting
call plug#end()

colorscheme shades_of_purple
set termguicolors

let g:airline_theme='shades_of_purple'
if !exists('g:airline_symbols')                 " Add airline symbols to vim-airline
	let g:airline_symbols = {}
endif

let g:airline_section_z='LN: %l / %L'           " Set the Z section of airline to be current  nenumber
let g:airline_solarized_bg='dark'

let g:airline_left_sep = ''                    " powerline symbols
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'
