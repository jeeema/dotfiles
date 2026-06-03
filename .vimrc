set nocompatible

set fileencoding=utf-8
set ambiwidth=double

set confirm
set swapfile
set directory=.
set updatecount=64
set nobackup
set writebackup
set backupdir=.
set viminfo=
set noundofile
set autoread

set title
set relativenumber
set numberwidth=3
set ruler
set lazyredraw
set hidden
set wrap
set mouse=a
set ttymouse=xterm2

set showcmd
set cmdheight=1
set wildmenu
set laststatus=2

set visualbell t_vb=
set noerrorbells

filetype indent on
set autoindent
set smartindent

set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

"Folding"


"Search"
set showmatch
set ignorecase
set smartcase
set showmatch
set wrapscan
set incsearch
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"Keymaps"
nnoremap j gj
nnoremap k gk
nnoremap Y y$

set background=dark
"let g:hybrid_custom_term_colors = 1
"let g:hybrid_reduced_contrast = 1
"colorscheme solarized8
colorscheme default
if has ('termguicolors')
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
syntax on
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line
