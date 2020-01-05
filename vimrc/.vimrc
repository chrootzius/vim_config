"#########################################################
"#        _    __   ____   __  ___   ____     ______     #
"#       | |  / /  /  _/  /  |/  /  / __ \   / ____/     #
"#       | | / /   / /   / /|_/ /  / /_/ /  / /          #
"#     _ | |/ /  _/ /   / /  / /  / _, _/  / /___        #
"#    (_)|___/  /___/  /_/  /_/  /_/ |_|   \____/        #
"#                                                       #
"#########################################################
                               
" Load local vimrc.
set exrc secure

"            __            _           
"     ____  / /_  ______ _(_)___  _____
"    / __ \/ / / / / __ `/ / __ \/ ___/
"   / /_/ / / /_/ / /_/ / / / / (__  ) 
"  / .___/_/\__,_/\__, /_/_/ /_/____/  
" /_/            /____/                

" A.L.E. settings.
let g:ale_completion_enabled = 1
let g:ale_sign_error = "✗"
let g:ale_sign_warning = "⚠"
let b:ale_fixers = ['rubocop', 'shellcheck', 'rustfmt']

"A.L.E. Rust Settings
let g:ale_linters = {'rust': ['rls']}
let g:ale_rust_rls_executable = $HOME . '/.cargo/bin/rls'
let g:ale_rust_rls_toolchain = 'stable'

highlight ALEWarning ctermbg=DarkMagenta ctermfg=black
highlight ALEError ctermbg=DarkGray ctermfg=Black
highlight ALEErrorSign ctermbg=Blue ctermfg=Black
highlight ALEWarningSign ctermbg=Green ctermfg=Black

" Airline settings.
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_theme='wal'

" NERDtree settings.
let NERDTreeShowHidden=1

" FZF settings.
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_commits_log_options = '--color=always --pretty=format:"%C(auto)%h %<(18)%an %d %s %C(green)%cr"'

"               __  __  _                 
"    ________  / /_/ /_(_)___  ____ ______
"   / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
"  (__  )  __/ /_/ /_/ / / / / /_/ (__  ) 
" /____/\___/\__/\__/_/_/ /_/\__, /____/  
"                           /____/        

" General settings.
set ttyfast
set splitbelow
set splitright
set copyindent
set autoindent
set lazyredraw
set smartindent
set nocompatible
set encoding=utf-8
set relativenumber nu
set backspace=indent,eol,start

" Highlight search results.
set hlsearch

" Enable wildmenu == show tab completion results.
set wildmenu

" Expand tabs to spaces
set expandtab

" Use zsh as vim shell.
set shell=zsh

" Set filewidth.
set textwidth=80
set colorcolumn=81

" needs to be after nocompatible
set iskeyword-=_

" Make Ctrl-a and Ctrl-x working with Base-10 numbers.
set nrformats-=octal

" Spellcheckin.
set complete+=d,kspell

" Enable persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Set path to local working dir.
let &path = getcwd() . '/**'

" Enable syntax highlighting.
syntax on
filetype on
filetype plugin indent on

" Color scheme settings.
set background=dark

" Spellcheking related highlighting.
" Needs to be loaded after theme otherwise the them will overrride highlighting
" settings.
hi clear SpellBad
hi SpellBad cterm=underline

" Used shiftwidth settings.
let blacklist =
        \ ['html', 'css', 'json', 'yaml', 'cpp', 'rust', 'puppet', 'pp', 'ruby']
augroup types
	au BufRead,BufNewFile,BufNew *
		\ call SetSw(index(blacklist, &ft), len(blacklist))
	au BufRead,BufNewFile,BufNew *
	    \ call SetZshFiletype()
	au BufRead,BufNewFile,BufNew *.asm set filetype=nasm
	au BufRead,BufNewFile,BufNew *.nix set filetype=yaml
	au BufRead,BufNewFile,BufNew *.pp  set filetype=puppet
augroup END

augroup K
	autocmd FileType vim setlocal keywordprg=:help
	autocmd FileType help setlocal keywordprg=:help
augroup END

"     ____                 __  _                 
"    / __/_  ______  _____/ /_(_)___  ____  _____
"   / /_/ / / / __ \/ ___/ __/ / __ \/ __ \/ ___/
"  / __/ /_/ / / / / /__/ /_/ / /_/ / / / (__  ) 
" /_/  \__,_/_/ /_/\___/\__/_/\____/_/ /_/____/  

" Filetype detection and set shiftwidth according to filetype.
function! SetSw(index, length) "{{{
	if a:index<0
		let sw=4
	elseif a:index==5
		let sw=4
		set colorcolumn=81,101 textwidth=100
	else
		let sw=2
	endif
	set modifiable
	execute "set tabstop=".sw
	execute "set softtabstop=".sw
	execute "set shiftwidth=".sw
endfunction "}}}

" Set filetype of zsh config files to sh.
function! SetZshFiletype() "{{{
    if &filetype ==# 'zsh'
        set filetype=sh
    endif
endfunction "}}}

" Execute make.
function! Make() "{{{
    execute ':w'
    execute ':make!'
endfunction "}}}

" Execute make clean.
function! MakeClean() "{{{
    execute ':w'
    execute ':make! clean'
endfunction "}}}

" Save current sessoin as $HOME/.vim/sessions/session-201911241740.vim
function! SaveCurrentSession() "{{{
    let path = $HOME . "/.vim/sessions/"
    let session_name = "session" . strftime("-%Y%m%d%H%M%S.vim")"
    let session = path . session_name
    let latest = path . "latest"
    execute "mksession " . session
    execute "!if [ -L " . latest . " ]; then rm " . latest . ";fi"
    execute "!ln -s " . session . " " . latest
endfunction "}}}

" Load latest session.
function! LoadLatestSession() "{{{
    let path = $HOME . "/.vim/sessions/"
    let latest = path . "latest"
    execute "source " . latest
endfunction "}}}

"     __                                          _                 
"    / /_____  __  ______ ___  ____ _____  ____  (_)___  ____ ______
"   / //_/ _ \/ / / / __ `__ \/ __ `/ __ \/ __ \/ / __ \/ __ `/ ___/
"  / ,< /  __/ /_/ / / / / / / /_/ / /_/ / /_/ / / / / / /_/ (__  ) 
" /_/|_|\___/\__, /_/ /_/ /_/\__,_/ .___/ .___/_/_/ /_/\__, /____/  
"           /____/               /_/   /_/            /____/        

" Map leader key to space bar.
let mapleader = "\<Space>"

" Xclipboard yank and put.
nnoremap <silent> <Leader>yy "+yy
nnoremap <silent> <Leader>y "+y
nnoremap <silent> <Leader>p o<ESC>"+p
" File navigation.
nnoremap <silent> <Leader><Space> :NERDTreeToggle<CR>
nnoremap <Leader>o :tabnew 
nnoremap <Leader>f :find 

" Usefull mappings for writing code.
nnoremap <silent> <leader>m :call Make()<cr>
nnoremap <silent> <leader>mc :call MakeClean()<cr>
nnoremap <silent> gf <C-W>gf
vnoremap <silent> gf <C-W>gf

" Save file as root.
cmap w!! w !sudo tee % >/dev/null

" Split navigation.
nnoremap <silent> <Leader>h :split<CR>
nnoremap <silent> <Leader>v :vsplit<CR>

" Tab navigation.
nnoremap <silent> <Leader>k :tabnext<CR>
nnoremap <silent> <Leader>j :tabprevious<CR>

" Spell checking for non code writing.
nnoremap <silent> <Leader>s :setlocal spell! spelllang=en_us<CR>

" Reload config on the fly.
nnoremap  <silent> <Leader>r :source $MYVIMRC<CR>

" Mapping redo command to U.
nnoremap <silent> <S-u> :redo<CR>

" Search/replace.
nnoremap <Leader>c :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap <silent> <Leader>u :let @/=''<CR>

" FZF commands.
nnoremap <tab><tab> :Files<CR>
nnoremap <leader><tab> :Rg<CR>
nnoremap <leader>gc :Commits<CR>

" Open terminal in vsplit.
nnoremap <leader>t :vsplit<cr>:term ++curwin<CR>

" Session management.
nnoremap <silent> <leader>ss :call SaveCurrentSession()<CR>
nnoremap <silent> <leader>ls :call LoadLatestSession()<CR>

"                                                   __    
"   _________  ____ ___  ____ ___  ____ _____  ____/ /____
"  / ___/ __ \/ __ `__ \/ __ `__ \/ __ `/ __ \/ __  / ___/
" / /__/ /_/ / / / / / / / / / / / /_/ / / / / /_/ (__  ) 
" \___/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/____/  
"                                                         

" Make ctags.
command! MakeTags !ctags -R .

"                              _                      __        __
"   ___  _  ______  ___  _____(_)___ ___  ___  ____  / /_____ _/ /
"  / _ \| |/_/ __ \/ _ \/ ___/ / __ `__ \/ _ \/ __ \/ __/ __ `/ / 
" /  __/>  </ /_/ /  __/ /  / / / / / / /  __/ / / / /_/ /_/ / /  
" \___/_/|_/ .___/\___/_/  /_/_/ /_/ /_/\___/_/ /_/\__/\__,_/_/   
"         /_/                                                     

" Experimental settings.
