"------------------------------------------------------------------------------
" GENERAL
"------------------------------------------------------------------------------
set encoding=utf-8            " Ensure encoding is UTF-8
set nocompatible              " Disable Vi compatability
set mouse=a                   " Enable mouse in all modes
set hidden                    " Allow unwritten buffers

let mapleader = ","              " set leader
"-----------------------------------------------------------------------------
" PLUGIN MANAGEMENT
"-----------------------------------------------------------------------------
filetype off
call plug#begin('~/.vim/plugged')
Plug 'ctrlpvim/ctrlp.vim'         " Quick file navigation
Plug 'tpope/vim-commentary'       " Quickly comment lines out and in
Plug 'tpope/vim-fugitive'         " Help formatting commit messages
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chriskempson/base16-vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/vim-peekaboo'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'jlanzarotta/bufexplorer'
Plug 'milkypostman/vim-togglelist'
"Plug 'tpope/vim-surround'         " surround text objects
Plug 'tpope/vim-unimpaired'       "
Plug 'tpope/vim-repeat'       "
Plug 'mbbill/undotree'
Plug 'svermeulen/vim-easyclip' " simplified clipboard functionality (look into)
"Plug 'tpope/vim-git'
"Plug 'tpope/vim-dispatch'         " Allow background builds
Plug 'airblade/vim-gitgutter'
"if has('nvim')
"  Plug 'zchee/deoplete-go', { 'do': 'make' }
"endif               " Helpful plugin for Golang dev
Plug 'posva/vim-vue'
"Plug 'christoomey/vim-tmux-navigator'
"Plug 'kshenoy/vim-signature'  "mark list
"Plug 'ekalinin/Dockerfile.vim'
"Plug 'tmux-plugins/vim-tmux-focus-events'
"Plug 'sirver/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'vim-syntastic/syntastic'
Plug 'vim-scripts/scratch.vim'
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
" autocmd FileType go nmap <leader>ga <Plug>(go-alternate-edit)
" autocmd FileType go nmap <leader>gd :GoDeclsDir<CR>
" autocmd FileType go nmap <leader>gl :GoLint<CR>
" autocmd FileType go nmap <leader>gv :GoVet<CR>
" autocmd FileType go nmap <leader>gg <Plug>(go-generate)
" using \ as a "leader/localleader" for specific files
autocmd FileType go nmap \a <Plug>(go-alternate-edit)
autocmd FileType go nmap \d :GoDeclsDir<CR>
autocmd FileType go nmap \l :GoLint<CR>
autocmd FileType go nmap \v :GoVet<CR>
autocmd FileType go nmap \t :GoTest<CR>
autocmd FileType go nmap \g <Plug>(go-generate)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

"autocmd FileType go nmap <leader>gb :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap \b :<C-u>call <SID>build_go_files()<CR>

function! s:toggle_coverage()
    call go#coverage#BufferToggle(!g:go_jump_to_error)
    highlight ColorColumn ctermbg=235
    highlight NonText ctermfg=239
    highlight SpecialKey ctermfg=239
    highlight goSameId term=bold cterm=bold ctermbg=250 ctermfg=239
endfunction

"autocmd FileType go nmap <leader>gc :<C-u>call <SID>toggle_coverage()<CR>
autocmd FileType go nmap \c :<C-u>call <SID>toggle_coverage()<CR>

let g:go_list_type = "quickfix"
:autocmd FileType qf wincmd J


" easyclip
let g:EasyClipShareYanks = 1
let g:EasyClipShareYanksFile = '.easyclip'
let g:EasyClipUseCutDefaults = 0
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
let g:EasyClipUsePasteToggleDefaults = 0

"tagbar
let g:tagbar_autopreview = 1
let g:tagbar_type_go = {
    \ 'kinds' : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions',
        \ '?:unknown',
    \ ],
\ }


" bufexplorer
let g:bufExplorerSortBy = 'mru'        " Sort by most recently used. (This is default)
let g:bufExplorerShowRelativePath = 1  " Show relative paths.

""-----------------------------------------------------------------------------
"" RUBY CONFIG
""-----------------------------------------------------------------------------
"autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

""-----------------------------------------------------------------------------
"" JS stuff CONFIG
""-----------------------------------------------------------------------------
"autocmd FileType vue setlocal expandtab shiftwidth=2 tabstop=2

"autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2
""-----------------------------------------------------------------------------
"" CTRL-P CONFIG
""-----------------------------------------------------------------------------
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn|vagrant)|node_modules)$',
  \ 'file': '\v\.(swp|zip|exe|so|dll|a)$',
  \ }
" stop setting git repo as root path
let g:ctrlp_working_path_mode = ''

set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching
let g:sneak#use_ic_scs = 1

if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

let g:undotree_WindowLayout = 2

""------------------------------------------------------------------------------
"" APPEARANCE
""------------------------------------------------------------------------------
"syntax on               " enable syntax highlighting
set number              " show line numbers
set relativenumber
set ruler               " show lines in lower right
set nowrap              " don't wrap lines eva!

let base16colorspace=256
if filereadable(expand("$HOME/.vimrc_background"))
  source $HOME/.vimrc_background
endif
set cursorline          " highlight current line
set highlight=sbr       " invert and bold status line
let loaded_matchparen = 1

set colorcolumn=80      " highlight col 80
highlight ColorColumn ctermbg=235
set listchars=tab:▸\ ,eol:¬,trail:· " show whitespace characters
set list                " enable display of invisible characters

"" invisible character colors
highlight NonText ctermfg=239
highlight SpecialKey ctermfg=239

""------------------------------------------------------------------------------
"" BEHAVIOR
""------------------------------------------------------------------------------
set backspace=indent,eol,start  " enable better backspacing
set noswapfile                  " disable swap files
set nowb                        " disable writing backup
set textwidth=78                " global text columns breaks here to new line
set formatoptions+=l            " don't break long lines less they are new

set hlsearch                    " highlight search results
set incsearch                   " incremental searches
set smartcase                   " ignore case if lower, otherwise match case
set splitbelow                  " split panes on the bottom
set splitright                  " split panes to the right

set history=10000               " keep a longer history
set wildmenu                    " allow for menu suggestions

"set autowrite                   " automatically write file on `:make`

"set autoread                    " automatically reload the file if changed elsewhere
"au FocusGained,BufEnter * :checktime

autocmd BufWritePre * :%s/\s\+$//e " strip trailing whitespace on save
autocmd BufLeave * silent! wall    " save on lost focus

"" tab behavior
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set timeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
"" smaller indents for yaml
"autocmd Filetype yaml setlocal tabstop=2 shiftwidth=2 expandtab

"" Format JSON with jq
"fun! PrettyJSON()
"  %!jq .
"  set filetype=json
"endfun

""------------------------------------------------------------------------------
"" LEADER MAPPINGS
""------------------------------------------------------------------------------

"" switch between files
nnoremap <leader><leader> <c-^>

"" file save M-w and on mac that maps to ∑
nmap <M-w> <Esc>:w<cr>
nmap ∑ <Esc>:w<cr>
imap <M-w> <Esc>:w<cr>
imap ∑ <Esc>:w<cr>

"" file quiet M-q and on mac that maps to œ
nmap <M-q> <Esc>:q<cr>
nmap œ <Esc>:q<cr>

"" quickly Open vimrc
nmap <silent> <leader>ev :edit $MYVIMRC<cr>
"" load vimrc into memory
nmap <silent> <leader>ee :source $MYVIMRC<cr>

" nmap ff :call fzf#run(fzf#wrap({
"  \  ‘source’: ‘git ls-files --exclude-standard --others --cached,
"  \  ‘sink’: ‘edit’
"  \  }))<Enter>
"" fzf and ripgrep
nmap <leader>fo :Files<CR>
nmap <leader>fb :Buffers<CR>
nmap <leader>fg :GFiles?<CR>
nmap <leader>fw :Windows<CR>
nmap <leader>fm :Marks<CR>
nmap <leader>ff :Find<space>
nmap <leader>fd :DirOpen<CR>
nmap <leader>fc :Commits<CR>
nmap <leader>fC :BCommits<CR>
nmap <leader>fl :Lines<space>
nmap <leader>fL :BLines<space>
command! -bang -nargs=* Find call fzf#vim#grep( 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" '.shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=* DirOpen call fzf#vim#files(expand('%:p:h'))

let $FZF_DEFAULT_OPTS = '--bind up:preview-up,down:preview-down'

nnoremap <F2> :UndotreeToggle<cr>
nmap <F3> :NERDTreeToggle<CR>
set pastetoggle=<F4>
"toggle spell
nmap <F5> :setlocal spell! spelllang=en_us<CR>
imap <F5> <C-o>:setlocal spell! spelllang=en_us<CR>
nmap <F8> :TagbarOpenAutoClose<CR>
"toggle ignorecase
nmap <F9> :set ignorecase! ignorecase?


"" spelling ]s moves to next [s moves to prev. z= suggests spelling changes
hi clear SpellBad
hi SpellBad cterm=underline
hi clear SpellCap
hi SpellCap cterm=underline
hi clear SpellRare
hi SpellRare cterm=underline
hi clear SpellLocal
hi SpellLocal cterm=underline
""-----------------------------------------------------------------------------
"" Marks related things vim-signature
""-----------------------------------------------------------------------------
"" quick open list of marks
"nmap <leader>m :Marks<CR>
"" defaults from vim-signature
"" m, place the next available mark
"" m<space> delete all marks from current buffer
"" m<bs> delete all marks from current buffer
"" m/ open list and display marks from current buffer
""
"nnoremap <leader>=j :call PrettyJSON()<cr>

"" clear the search buffer when hitting space
nnoremap <space> :nohlsearch<cr>

"" reselect when indenting
vnoremap < <gv
vnoremap > >gv

"" clipboard fusion!
set clipboard^=unnamed clipboard^=unnamedplus

"" turn folding on and open by default
" set foldmethod=syntax
" set foldlevel=99

"" remove the need to hit c-w for navigating splits
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l

nnoremap <c-e> 10<c-e>
nnoremap <c-y> 10<c-y>

"map <C-n> :cnext<CR>
"map <C-m> :cprevious<CR>
nnoremap <leader>a :<C-u>call ClosePreviewWindowOrQuicklist()<CR>


fun! ClosePreviewWindowOrQuicklist()
    for nr in range(1, winnr('$'))
        if getwinvar(nr, "&pvw") == 1
            " found a preview
            pclose
            return
        endif
    endfor
    cclose
    return
endfun

" spelling function or find a way to have spell suggestion in normal mode z=
" look the same as <c-x>s in insert mode
" option: <localleader>s ea<cx>s


augroup BgHighlight
    autocmd!
    autocmd WinEnter * set colorcolumn=80
    autocmd WinEnter * set cul
    autocmd WinEnter * set relativenumber
    autocmd WinLeave * set colorcolumn=0
    autocmd WinLeave * set nocul
    autocmd WinLeave * set norelativenumber
augroup END
