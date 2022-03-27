" General default vim settings "
set encoding=utf-8
set tabstop=4 softtabstop=4		" tabs goes 4 spaces, not 8 (default)
set shiftwidth=4
set expandtab 					" converts tabs to spaces. Real tab with Ctrl-V <Tab>
set shiftwidth					" changes the spaces inserted for indentation
set autoindent                  " always set autoindenting on
set incsearch					" when you search with / display the text incrementally
set number                      " set line numbers
set relativenumber              " set relative numbers on
set mouse+=a                    " Turn on the mouse
set smartcase                   " ignore case if all lowercase (for searching)
set nobackup                    " CoC has some problems with backups
set nowritebackup               " I live on the edge
set scrolloff=5                 " leave 5 lines below the cursor when scrolling down, and viceversa

" --- Auto-install vim-plug if not already installed --- "
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif 


call plug#begin()

" Themes and things of Vim itself
Plug 'Rigellute/shades-of-purple.vim'           " based on shades-of-purple-vscode
Plug 'rakr/vim-one'                             " Vim One Dark theme
Plug 'xiyaowong/nvim-transparent'               " make the background transparent
Plug 'vim-airline/vim-airline'                  " Vim Status line
Plug 'vim-airline/vim-airline-themes'           " And its themes
Plug 'nvim-telescope/telescope.nvim'            " Find files fzf
Plug 'nvim-lua/plenary.nvim'                    " requiered for nvim-telescope
Plug 'nvim-treesitter/nvim-treesitter'          " requiered for nvim-telescope
Plug 'nvim-telescope/telescope-fzy-native.nvim' " fzf, but faster
Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocompletion
Plug 'yuttie/comfortable-motion.vim'            " smooth scrolling
Plug 'mbbill/undotree'                          " for unlimited power Ctrl Z
Plug 'preservim/nerdtree' |                     " folder tree for vim
        \ Plug 'Xuyuanp/nerdtree-git-plugin'    " git icons for nerdtree

Plug 'ncm2/ncm2'                                " Completion-[dep]: nvim-0.2.2, nvim-yarp, python3
Plug 'ncm2/ncm2-bufword'                        " Completes words in buffer
Plug 'ncm2/ncm2-path'                           " Completes paths
Plug 'roxma/nvim-yarp'                          " remote plugin framework required for ncm2

" General code plugins
Plug 'sheerun/vim-polyglot'                     " Solid language pack for vim
Plug 'vim-syntastic/syntastic'                  " Syntax checker for vim
Plug 'jiangmiao/auto-pairs'                     " Automatically close parenthesis, etc
Plug 'ap/vim-css-color'                         " fancy color highligter for CSS
Plug 'tpope/vim-fugitive'                       " a git wrapper
Plug 'rbong/vim-flog'                           " a git branch viewer
Plug 'airblade/vim-gitgutter'                   " see + - and ~ on the left of the line numbers
Plug 'wakatime/vim-wakatime'                    " Wakatime for counting time coding
Plug 'andweeb/presence.nvim'                    " discord rich presence
Plug 'junegunn/vim-emoji'                       " emojis in vim

" Pythonic thingies
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' } " Python syntax highliting
Plug 'ncm2/ncm2'                                " Python autocompletion
Plug 'roxma/nvim-yarp'                          " requierement for ncm2
Plug 'fisadev/vim-isort'                        " Automatically sort python imports
Plug 'jmcantrell/vim-virtualenv'                " vim plugin for working python envs
Plug 'psf/black', { 'branch': 'stable' }        " black formatter official plugin

" Plug 'ncm2/ncm2-bufword'                        " Completion sources
" Plug 'ncm2/ncm2-path'                           " ncm2 Filepath completion
 
" Always add vim-devicons as the last one!
Plug 'ryanoasis/vim-devicons'                   " devicons for nerdtree
call plug#end()

colorscheme shades_of_purple                    " Theme settings
set termguicolors                               " To make the colorscheme actually work
let g:python_host_prog = '/usr/bin/python3'
let g:python3_host_prog = '/usr/bin/python3'
let g:transparent_enabled = 1                   " transparency only works when you toggle it, documentation doesnt help. Better change the plugin"

" --------------- PlugIn Settings ---------------  "
" Telescope to search files on the project. Settings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" vim-airline settings
let g:shades_of_purple_airline = 1
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

" vim-gitgutter
let g:gitgutter_highlight_lines = 1
set updatetime=100                              " which determines how long (in
                                                " milliseconds) the plugin will wait after you stop typing before it updates the
                                                " signs.  Vim's default is 4000.  I recommend 100.  Note this also controls how
                                                " long vim waits before writing its swap file.

                                                " ncm2 settings
autocmd BufEnter * call ncm2#enable_for_buffer() 

" NERDTree settings
let g:NERDTreeGitStatusShowIgnored = 1 " a heavy feature may cost much more time. default: 0
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
" IMPORTANT: :help Ncm2PopupOpen for more info
set completeopt=noinsert,menuone,noselect


" -------- CoC Config -------- 
"  After you installed CoC, run
"  :CocInstall coc-marketplace
"  to instal a looooong list with all the plugins available.
"  list them with
"  :CocList marketplace
"  I instaled:
"  :CocInstall coc-pyright coc-html coc-css coc-sql coc-toml coc-markdownlint
"  coc-json coc-htmldjango
"  Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

