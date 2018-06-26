"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set encoding=utf-8            " Ensure encoding is UTF-8
set nocompatible              " Disable Vi compatability
set mouse=a                   " Enable mouse in all modes
set hidden                    " Allow unwritten buffers

"-----------------------------------------------------------------------------
" PLUGIN MANAGEMENT
"-----------------------------------------------------------------------------
filetype off
"call plug#begin('~/.local/share/nvim/plugged')
call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'         " Quick file navigation
Plug 'tpope/vim-surround'         " surround text objects
Plug 'tpope/vim-repeat'       "
Plug 'tpope/vim-commentary'       " Quickly comment lines out and in
Plug 'tpope/vim-fugitive'         " Help formatting commit messages
Plug 'tpope/vim-git'
Plug 'tpope/vim-dispatch'         " Allow background builds
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
"Plug 'jlanzarotta/bufexplorer'
if has('nvim')
  Plug 'zchee/deoplete-go', { 'do': 'make' }
endif               " Helpful plugin for Golang dev
Plug 'vim-scripts/bufkill.vim'    " Kill buffers and leave windows intact
Plug 'wesQ3/vim-windowswap'       " Easy window swapping
"Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
"fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chriskempson/base16-vim'
Plug 'posva/vim-vue'
Plug 'christoomey/vim-tmux-navigator'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/vim-peekaboo'
Plug 'jlanzarotta/bufexplorer'
Plug 'kshenoy/vim-signature'  "mark list
Plug 'ekalinin/Dockerfile.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-syntastic/syntastic'
Plug 'mtth/scratch'
call plug#end()                   " Complete vunde initialization

" detect file type, turn on that type's plugins and indent preferences
filetype plugin indent on

"-----------------------------------------------------------------------------
" VIM-GO CONFIG
"-----------------------------------------------------------------------------
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['go', 'golint', 'govet']
let g:syntastic_aggregate_errors = 1

" highlight go-vim
highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
set updatetime=100 " updates :GoInfo faster

" vim-go command shortcuts
autocmd FileType go nmap <leader>ga <Plug>(go-alternate-edit)
autocmd FileType go nmap <leader>gd :GoDeclsDir<CR>
autocmd FileType go nmap <leader>gl :GoLint<CR>
autocmd FileType go nmap <leader>gv :GoVet<CR>
autocmd FileType go nmap <leader>gg <Plug>(go-generate)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>gb :<C-u>call <SID>build_go_files()<CR>

function! s:toggle_coverage()
    call go#coverage#BufferToggle(!g:go_jump_to_error)
    highlight ColorColumn ctermbg=235
    highlight NonText ctermfg=239
    highlight SpecialKey ctermfg=239
    highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
endfunction

autocmd FileType go nmap <leader>gc :<C-u>call <SID>toggle_coverage()<CR>

"-----------------------------------------------------------------------------
" RUBY CONFIG
"-----------------------------------------------------------------------------
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

"-----------------------------------------------------------------------------
" JS stuff CONFIG
"-----------------------------------------------------------------------------
autocmd FileType vue setlocal expandtab shiftwidth=2 tabstop=2

autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
"-----------------------------------------------------------------------------
" CTRL-P CONFIG
"-----------------------------------------------------------------------------
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|vagrant)|node_modules)$',
  \ 'file': '\v\.(swp|zip|exe|so|dll|a)$',
  \ }
" stop setting git repo as root path
let g:ctrlp_working_path_mode = ''

"-----------------------------------------------------------------------------
" snippets
"-----------------------------------------------------------------------------
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["$HOME/.vim/snips"]

"-----------------------------------------------------------------------------
" nerd tree config
"-----------------------------------------------------------------------------
nmap <C-n> :NERDTreeToggle<CR>
"------------------------------------------------------------------------------
" APPEARANCE
"------------------------------------------------------------------------------
syntax on               " enable syntax highlighting
set number              " show line numbers
set relativenumber
set ruler               " show lines in lower right
set nowrap              " don't wrap lines eva!

set background=dark
let base16colorspace=256  " Access colors present in 256 colorspace

if filereadable(expand("$HOME/.vimrc_background"))
  source $HOME/.vimrc_background
endif
set cursorline          " highlight current line
set highlight=sbr       " invert and bold status line
let loaded_matchparen = 1

set t_Co=256            " set 256 color
set colorcolumn=80      " highlight col 80
highlight ColorColumn ctermbg=235
"set listchars=tab:▸\ ,eol:¬,trail:·,space:. " show whitespace characters
set listchars=tab:▸\ ,eol:¬,trail:· " show whitespace characters
set list                " enable display of invisible characters

" invisible character colors
highlight NonText ctermfg=239
highlight SpecialKey ctermfg=239

"------------------------------------------------------------------------------
" BEHAVIOR
"------------------------------------------------------------------------------
set backspace=indent,eol,start  " enable better backspacing
set noswapfile                  " disable swap files
set nowb                        " disable writing backup
set textwidth=78                " global text columns
set formatoptions+=l            " don't break long lines less they are new

set hlsearch                    " highlight search results
set smartcase                   " ignore case if lower, otherwise match case
set splitbelow                  " split panes on the bottom
set splitright                  " split panes to the right

set history=10000               " keep a longer history

set wildmenu                    " allow for menu suggestions

set autowrite                   " automatically write file on `:make`

set autoread                    " automatically reload the file if changed elsewhere
au FocusGained,BufEnter * :checktime

autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save
autocmd BufLeave * silent! wall    " save on lost focus

" tab behavior
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" smaller indents for yaml
autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab

" Format JSON with jq
fun! PrettyJSON()
  %!jq .
  set filetype=json
endfun

"------------------------------------------------------------------------------
" LEADER MAPPINGS
"------------------------------------------------------------------------------
let mapleader = ","              " set leader

" switch between files
nnoremap <leader><leader> <c-^>

" file save M-w and on mac that maps to ∑
nmap <M-w> <Esc>:w<cr>
nmap ∑ <Esc>:w<cr>
imap <M-w> <Esc>:w<cr>
imap ∑ <Esc>:w<cr>

" file quiet M-q and on mac that maps to œ
nmap <M-q> <Esc>:q<cr>
nmap œ <Esc>:q<cr>

" quickly Open vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<cr>
" load vimrc into memory
nmap <silent> <leader>ee :source $MYVIMRC<cr>

" fzf and ripgrep
nmap <leader>fo :Files<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fg :GFiles?<CR>
nmap <leader>fc :BCommits<CR>

nmap <leader>ff :Find<space>
command! -bang -nargs=* Find call fzf#vim#grep( 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" '.shellescape(<q-args>), 1, <bang>0)

let $FZF_DEFAULT_OPTS = '--bind up:preview-up,down:preview-down'

nmap <leader>bd :bp\|bd # <CR>

" spelling ]s moves to next [s moves to prev. z= suggests spelling changes
nmap <leader>s :set spell
set spelllang=en_us
"-----------------------------------------------------------------------------
" Marks related things vim-signature
"-----------------------------------------------------------------------------
" quick open list of marks
nmap <leader>m :Marks<CR>
" defaults from vim-signature
" m, place the next available mark
" m<space> delete all marks from current buffer
" m<bs> delete all marks from current buffer
" m/ open list and display marks from current buffer
"
nnoremap <leader>=j :call PrettyJSON()<cr>

" clear the search buffer when hitting space
nnoremap <space> :nohlsearch<cr>

" reselect when indenting
vnoremap < <gv
vnoremap > >gv

" clipboard fusion!
set clipboard^=unnamed clipboard^=unnamedplus

" turn folding on and open by default
set foldmethod=syntax
set foldlevel=99

" remove the need to hit c-w for navigating splits
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l

nnoremap <c-e> 10<c-e>
nnoremap <c-y> 10<c-y>
