set nocompatible
set number
"set relativenumber
set numberwidth=4
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
"set softtabstop=4
"set expandtab
set ignorecase
set smartcase
set incsearch
"set wrapscan
set go-=T
set go-=m
set go-=r
set go-=L
set go-=e
"set winheight=30
set winminheight=0
set wildmode=list:longest
set wildmenu
set wildcharm=<C-Z>
set completeopt=longest,menuone,preview
set showcmd
set showmode
set undofile
set undodir=~/.vim/undo
set encoding=utf-8
set fileencodings=utf-8,latin2
set hlsearch
"set diffopt+=iwhite
set splitbelow
set splitright
set foldlevel=12
set foldmethod=indent
"set foldnestmax=2
set laststatus=2
"set t_Co=256
set colorcolumn=80
set wrap
set fileformats="unix" ",dos
set mouse=a
set ttymouse=xterm2
"set cursorline
set list
set listchars=tab:>\ ,eol:¬,trail:· "▸
set nofixendofline  " don't add missing eol
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winpos,winsize,resize
" gvim doesn't source .bashrc so we need to provide the path to the ropevim
" through the PYTHONPATH's variable in this way
" otherwise there were "No module named rope_omni" error message
let python_version='3.9'
let $PYTHONPATH.=':/home/derenio/.vim/bundle/ropevim/'
let $PYTHONPATH.=':/home/derenio/.vim/bundle/ropemode/'
let $PYTHONPATH.=':/home/derenio/.local/lib64/python' . python_version . '/'
let $PYTHONPATH.=':/home/derenio/.local/lib64/python' . python_version . '/site-packages/'
let $PATH.=':/home/derenio/.local/bin/'

"=================================== Vundle ===================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ambv/black'
Plugin 'fisadev/vim-isort'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-syntastic/syntastic'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'integralist/vim-mypy'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'cespare/vim-toml'
Plugin 'JuliaEditorSupport/julia-vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"================================= END Vundle =================================

" plugin allowing to easily install other plugins
filetype off
call pathogen#infect()
call pathogen#helptags()

syntax on
filetype plugin indent on

augroup hide_preview_window
	au!
	au InsertLeave * if pumvisible() == 0|pclose|endif
augroup END

augroup my_file_types
	au!
	au FileType coffee,typescript,css,less setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal et
	"au FileType *html* setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal noet
	" Hip new trend of using 2 spaces in badly designed languages:
	au FileType ruby,*html*,scss,javascript,javascript.jsx,jade,pug,json setlocal ts=2 | setlocal sw=2 | setlocal sts=2 | setlocal et
	"au FileType *html* setlocal ts=4 | setlocal sw=4 | setlocal sts=4
	" Required vim-flake8, the functionality is already provided by syntastic
	"au FileType python map <buffer> <F5> :call Flake8()<CR>
	au FileType python nnoremap <leader>r :w<CR>:!python %<CR>
	"isort
	au FileType python nnoremap <leader><C-i> :Isort<CR>
	" Manually set .sh filetype because vim detects it as python
	au BufRead,BufNewFile *.sh setlocal filetype=sh
	au FileType sh nnoremap <leader>r :w<CR>:!sh %<CR>
	au FileType javascript nnoremap <leader>r :w<CR>:!node %<CR>
	au FileType c nnoremap <leader>r :w<CR>:!gcc -std=c99 % && ./a.out<CR>
	au FileType haskell nnoremap <leader>r :w<CR>:!runhaskell %<CR>
	au FileType julia nnoremap <leader>r : w<CR>:!julia %<CR>
	au FileType coffee map <buffer> <F5> :CoffeeLint<CR>
	au FileType coffee map <buffer> <leader>j :CoffeeCompile<CR>
	au FileType coffee vmap <buffer> <leader>j :CoffeeCompile<CR>
	" CoffeeRun hangs on compiling nodejs' whole modules
	" au FileType coffee map <buffer> <leader>r :CoffeeRun<CR>
	au FileType coffee vmap <buffer> <leader>r :CoffeeRun<CR>
	au BufRead,BufNewFile *.kv set filetype=kivy
	au FileType python,kivy setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal et
	au FileType java setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal et
	au FileType xml,xsd,yaml setlocal ts=2 | setlocal sw=2 | setlocal sts=2
	au FileType sls setlocal ts=2 | setlocal sw=2 | setlocal sts=2 | setlocal et
	au FileType markdown setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal et
	au FileType haskell setlocal ts=4 | setlocal sw=4 | setlocal sts=4 | setlocal et
	" use globally defined wrap setting while diffing
	au FilterWritePre * if &diff | setlocal wrap< | endif
	" for python the filetype's plugin handles indent and smartindent causes
	" the '#' to move to the first column
	" http://stackoverflow.com/questions/2063175/vim-insert-mode-comments-go-to-start-of-line
	au FileType python setlocal nosmartindent
	" mnemonic: build latex
	au FIleType tex nnoremap <leader>bl :w<CR>:!pdflatex % && evince "%:r".pdf &<CR>
	" aws' elastic beanstalk uses yaml's syntax in their *.config files
	au BufRead,BufNewFile *.config setlocal filetype=yaml
	au BufRead,BufNewFile *.scss setlocal filetype=scss.css
	au BufRead,BufNewFile *.jl :setlocal filetype=julia
	" Auto-formatters
	au FileType python nnoremap <F4> :Isort<CR>
	au FileType python nnoremap <F5> :Black<CR>
	au FileType javascript* nnoremap <F5> :Prettier<CR>:w<CR>
augroup END


set background=dark
colorscheme molokai
augroup my_gui
	au!
	let s:default_font='xos4 Terminus 12'
	au GUIEnter * set columns=160 lines=80
	au GUIEnter * let &guifont=s:default_font
	"au GUIEnter * set guifont=xos4\ Terminus\ 12
	"au GUIEnter * set guifont=Source\ Code\ Pro\ 12
	"au GUIEnter * colorscheme molokai
	" Defining fonts' changing helpers
	" http://vim.wikia.com/wiki/Change_font_size_quickly
	let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
	let s:minfontsize = 6
	let s:maxfontsize = 20
	function! AdjustFontSize(amount)
	  if (has("gui_gtk2") || has("gui_gtk")) && has("gui_running")
		let fontname = substitute(&guifont, s:pattern, '\1', '')
		let cursize = substitute(&guifont, s:pattern, '\2', '')
		let newsize = cursize + a:amount
		if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
		  let newfont = fontname . newsize
		  let &guifont = newfont
		endif
	  else
		echoerr "You need to run the GTK2 version of Vim to use this function."
	  endif
	endfunction

	function! LargerFont()
	  call AdjustFontSize(1)
	endfunction
	command! LargerFont call LargerFont()

	function! SmallerFont()
	  call AdjustFontSize(-1)
	endfunction
	command! SmallerFont call SmallerFont()

	command! ResetFont :let &guifont=s:default_font


	nnoremap <C-Up> :LargerFont<CR>
	nnoremap <C-Down> :SmallerFont<CR>
	nnoremap <C-PageUp> :ResetFont<CR>
augroup END

augroup custom_vim_maps
	au!
	" escape shortcut
	inoremap jj <ESC>
	" Easier access to omni-autocompetion
	" inoremap <C-Space> <C-x><C-o>

	" Avoid using <Shift>s
	nnoremap gb gT
	" nnoremap ;; :

	" faster split buffers navigation
	nnoremap <C-h> <C-W>h
	nnoremap <C-j> <C-W>j
	nnoremap <C-k> <C-W>k
	nnoremap <C-l> <C-W>l
	"nmap - <C-W>-
	"nmap + <C-W>+
	nnoremap n nzz
	nnoremap N Nzz
	nnoremap <C-p> <ESC>:set paste<CR>
	" mnemonic 'go next' used in git diffing with gvim
	nnoremap gon :qa<CR>
	nnoremap <leader>q :q<CR>

	nnoremap <Space> <Esc>:nohl<CR>:set nopaste<CR>
	nnoremap <F7> <Esc>:setlocal spell spelllang=pl<CR>
	nnoremap <F8> <Esc>:setlocal spell spelllang=en<CR>
	nnoremap <F6> <Esc>:setlocal nospell<CR>

	" open file from current buffer's directory
	"OLD" nnoremap <leader>x :e <C-R>=expand("%:p:h")<CR>/
	nnoremap <leader>x :e %:p:h<C-Z><C-Z>
	nnoremap <leader>ex :vsplit<CR>:Explore<CR>
	nnoremap <leader>E :Explore<CR>

	" tab navigation
	nnoremap tn :tabnew<CR>
	nnoremap tN :tabnew<CR>:tabmove -1<CR>
	nnoremap th :tabfirst<CR>
	nnoremap tj :tabnext<CR>
	nnoremap tk :tabprev<CR>
	nnoremap tl :tablast<CR>
	nnoremap tt :tabedit<Space>
	nnoremap tm :tabm<Space>
	nnoremap td :tabclose<CR>
	nnoremap t+ :tabmove +1<CR>
	nnoremap t= :tabmove +1<CR>
	nnoremap t- :tabmove -1<CR>

	" fugitive
	noremap <leader>gb :Gblame<CR>
	noremap <leader>gd :Gvdiff<CR>
	noremap <leader>gmd :Gvdiff master<CR>
	noremap <leader>gw :Gbrowse<CR>
	noremap <leader>gs :Gstatus<CR>

	" netrw
	let g:netrw_browsex_viewer = "browser_open.sh"

	" select last pasted text
	nnoremap gp `[v`]

	" edit vimrc and source it
	nnoremap <leader>ev :vsplit $MYVIMRC<CR>
	nnoremap <leader>sv :source $MYVIMRC<CR>

	" edit bashrc
	nnoremap <leader>eb :vsplit $HOME/.bashrc<CR>

	" python debugging
	nnoremap <leader>pd oimport ipdb; ipdb.set_trace()  # noqa<ESC>:w<CR>

	" insert current date
	nnoremap <leader>rd :r! LANG=en_EN date<CR>kJ

	" remove hidden buffers
	nnoremap <leader>w :call HiddenBuffersWipeout()<CR>

	" write file as superuser using the "tee" trick
	cmap w!! w !sudo tee % >/dev/null

	" decode 'quoted printable' text (presumably from email)
	" http://vim.wikia.com/wiki/Quoted_Printable_to_Plain
	nnoremap <leader>Q :%s/=\(\x\x\<BAR>\n\)/\=submatch(1)=='\n'?'':nr2char('0x'.submatch(1))/ge<CR>
	vnoremap <leader>Q :s/=\(\x\x\<BAR>\n\)/\=submatch(1)=='\n'?'':nr2char('0x'.submatch(1))/ge<CR>

	" indent/html.vim
	" make the 'img' tag's closing slash optional
	let g:html_indent_autotags = "br,input,img"

	" vim-markdown-preview
	let g:vim_markdown_preview_use_xdg_open=1
	let vim_markdown_preview_hotkey='<leader>p'
	" use app-text/grip to preview markdown
	let g:vim_markdown_preview_github=1

	" Edit ":global" search result in a new window
	command! -nargs=? Filter let @a='' | execute 'g/<args>/y A' | new | setlocal bt=nofile | put! a

	" Copy current file's path
	nnoremap <silent> <leader>cp :let @"=expand("%:p")<CR>

	" Make (or override existing) session
	" mnemonic: make session
	nnoremap <leader>ms :mksession! .Session.vim<CR>:wqa<CR>

	" Shortcut for :diffthis and :diffoff!
	nnoremap <leader>dt :diffthis<CR>
	nnoremap <leader>do :diffoff!<CR>
augroup END

augroup my_abbreviations
	"iabbrev <expr> dts strftime("%c")
	iabbrev <expr> dts system("LANG=en_EN date \| tr -d '\n'")
augroup END

augroup virtualenv
	" virtualenv activation
	if exists("$VIRTUAL_ENV")
	python3 << EOF
import sys, vim, os

ve_dir = vim.eval('$VIRTUAL_ENV')
ve_dir in sys.path or sys.path.insert(0, ve_dir)
activate_this = os.path.join(os.path.join(ve_dir, 'bin'), 'activate_this.py')

exec(open(activate_this).read(), dict(__file__=activate_this))
EOF

	" browse virtualenv packages
	let site_packages = $VIRTUAL_ENV . "/lib/python" . python_version . "/site-packages/"
	let $PYTHONPATH .= ":" . site_packages
	execute "nnoremap <leader>ve :e " . site_packages . "<C-Z>"

	endif
augroup END

" CommandT
let g:CommandTMaxFiles=200000  " default is 100000
let g:CommandTAlwaysShowDotFiles = 0
let g:CommandTCancelMap = ['<Esc>', '<C-c>']
let g:CommandTFileScanner = 'find'
let g:CommandTTraverseSCM = 'pwd'
"let g:CommandTInputDebounce = 50
let g:CommandTMatchWindowAtTop = 0
let g:CommandTMatchWindowReverse = 0
let g:CommandTScanDotDirectories = 1
let g:CommandTWildIgnore = &wildignore . ',.git/*,*.pyc,*.swp,' .
	\ '*/env/*,*/node_modules/*,*/bower_components/*,*/static/*,*/media/*,*/build/*,' .
	\ '*/dist/*,.*/tscache/*,.baseDir.ts,'
" Override the new defaults that use "CommandTOpen" (commandt#GotoOrOpen)
let g:CommandTAcceptSelectionCommand='e'
let g:CommandTAcceptSelectionTabCommand='tabe'
let g:CommandTAcceptSelectionSplitCommand='sp'
let g:CommandTAcceptSelectionVSplitCommand='vs'
augroup CommandT
	" The default mapping
	nmap <silent> <Leader>t <Plug>(CommandT)
	nmap <silent> <Leader>b <Plug>(CommandTMRU)
	nmap <silent> <Leader>j <Plug>(CommandTJump)
	" Search starting from
	" 1. current's file directory
	nnoremap <leader>ct :CommandT %:p:h<CR>
	" 2. virtual env
	if exists("site_packages")
		execute "nnoremap <leader>cve :CommandT " . site_packages . "<CR>"
	endif
	" Reload the CommandT
	" nmap <leader>cf <Plug>(CommandTFlush)
	nmap <silent> <leader>cf :CommandTFlush<CR>:CommandT<CR>
	nmap <silent> <leader>cg <Plug>(CommandTLine)
augroup END

" " ropevim
" augroup ropevim
" 	au!
" 	au FileType python nnoremap <leader>ra :RopeAnalyzeModule<CR>
" 	au FileType python nnoremap <leader>ro :RopeOrganizeImports<CR>0<CR><CR>
" 	au FileType python nnoremap <leader>ri :RopeAutoImport<CR>
" 	au FileType python imap <c-space> <C-R>=RopeCodeAssistInsertMode()<CR><C-P>
" augroup END
" let g:ropevim_vim_completion=0
" let g:ropevim_extended_complete=0
" let g:ropevim_guess_project=1
" let g:ropevim_open_files_in_tabs=1
" let g:ropevim_enable_autoimport=1
" let g:ropevim_autoimport_modules = ["os", "os.*","traceback","django.*"]

" pymode
let g:pymode_lint = 0
let g:pymode_lint_write = 0
let g:pymode_lint_checkers = []
let g:pymode_lint_ignore = 'C0110,C0301,E501'
let g:pymode_rope = 0

" jedi
let g:jedi#popup_on_dot = 0  " together with auto-selection this fails on classes' methods/fields that are dynamic
let g:jedi#popup_select_first = 1
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_command = "<leader>d"
let g:jedi#use_splits_not_buffers = "winwidth"
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#auto_close_doc = 1
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>f"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>rn"
let g:jedi#show_call_signatures = 1
let g:jedi#smart_auto_mappings = 1

" isort
let g:vim_isort_python_version = 'python3'

" ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"python-syntax
let python_highlight_all = 1

"autopep8
augroup autopep8
	au!
	au FileType python nnoremap <leader>ap :!autopep8 --max-line-length=79 --in-place --recursive -p 1000 %:p<CR>
augroup END

"vim-css-color
let g:cssColorVimDoNotMessMyUpdatetime = 1

"coffeelint
let g:coffee_lint_options = '--file /home/derenio/coffeelint.json'

"coffee tags
let g:CoffeeAutoTagDisabled=1  " Disables autotaging on save (Default: 0 [false])
let g:CoffeeAutoTagFile='./.tags'  " Name of the generated tag file (Default: ./tags)
let g:CoffeeAutoTagIncludeVars=0  " Includes variables (Default: 0 [false])
let g:CoffeeAutoTagTagRelative=1  " Sets file names to the relative path from the tag file location to the tag file location (Default: 1 [true])

" "Powerline
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
" let g:Powerline_symbols='fancy' "not supported by fonts

"Airline - successor of the Powerline
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline_detect_spell=1
let g:airline_theme='base16_monokai'
let g:airline_inactive_collapse=1
let g:airline#extensions#tabline#enabled = 1  " enhanced tabline
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#branch#displayed_head_limit = 10
let g:airline#extensions#branch#enabled = 1  " fugitive integration
let g:airline#extensions#hunks#enabled = 1  " display source control changes
let g:airline#extensions#syntastic#enabled = 1  " syntastic integration
let g:airline#extensions#tagbar#enabled = 0  " tagbar integration
" powerline symbols
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"TaskList
map <leader><leader>t <Plug>TaskList

"NERDTree
" map <leader>n :NERDTree %<CR>
" deactivate NERDTree
let loaded_nerd_tree=1

"Tagbar
map <leader>c :TagbarToggle<CR>

"Eclipse style autocomplete
"imap <C-Space> <C-x><C-u>

"syntastic
augroup syntastic
	au!
	nnoremap <leader>sc :SyntasticCheck<CR>:Errors<CR>
	"nnoremap <leader>se :Errors<CR>
augroup END
"sets python's default checker
"let g:syntastic_python_checkers = ['pylint', 'mccabe', 'pyflakes', 'flake8']
let g:syntastic_python_checkers = ['flake8']
" E501 - line length
let g:syntastic_python_flake8_args='--max-line-length=120 --ignore=D100,D101,D102,D103,D105,D200,D202,D205,D208,D210,W503,E203' "E226,D104,D209,D400,D401'
let g:syntastic_python_pylint_args='-d missing-docstring,empty-docstring' ",import-error,too-few-public-methods,no-self-use'
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_disabled_filetypes = []
let g:syntastic_auto_jump=0
let g:syntastic_error_symbol='✗'  " ಠ_ಠ'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_check_on_open = 1  " check on open and save
let g:syntastic_mode_map = {
	\ 'mode': 'active',
	\ 'passive_filetypes': ['java'] }

"typescript
let g:syntastic_typescript_checkers = ['tslint', 'tsuquyomi']
let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_disable_quickfix = 1
augroup typescript
	au!
	" Reload the TSServer for all the open project's files.
	au FileType typescript nnoremap <buffer> <leader>rp :TsuquyomiReloadProject<CR>
	" Rename variable
	au FileType typescript nmap <buffer> <leader>r <Plug>TsuquyomiRenameSymbol
	" Rename including comments
	au FileType typescript nmap <buffer> <leader>R <Plug>TsuquyomiRenameSymbolC
	" Go to definition
	au FileType typescript noremap <buffer> <leader>d v:call tsuquyomi#definition()<CR>
augroup END

"javascript tern
augroup typescript
	au!
	au FileType javascript nnoremap <buffer> <leader>d :TernDef<CR>
	au FileType javascript nnoremap <buffer> <leader>f :TernRefs<CR>
	au FileType javascript nnoremap <buffer> <leader>k :TernDoc<CR>
augroup END

"SuperTab
"augroup supertab
"	au!
"	au FileType python let g:SuperTabDefaultCompletionType = 'context'
"	au FileType java let g:SuperTabDefaultCompletionType = 'context'
"	au FileType java let g:SuperTabContextDefaultCompletionType="<c-x><c-u>"
"augroup END
"let g:SuperTabMappingForward = '<c-space>'
"let g:SuperTabMappingBackward = '<s-c-space>'

"Eclim
" let g:EclimPythonValidate=0
" let g:EclimCompletionMethod='omnifunc'
" augroup eclim
" 	au!
" 	au FileType java nnoremap <silent> <buffer> <leader>c :JavaCorrect<CR>
" 	au FileType java nnoremap <silent> <buffer> <leader>f :%JavaFormat<CR>
" 	au FileType java nnoremap <silent> <buffer> <leader>s :JavaImportOrganize<CR>
" 	au FileType java nmap <buffer> <leader>r :JavaRename
" 	au FileType java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
" 	au FileType java nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<cr>
" 	au FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
" augroup END


"Alloy4
augroup alloy
	au!
	au BufRead,BufNewFile *.als setfiletype alloy4
augroup END


"Remove hidden buffers
function! HiddenBuffersWipeout()
	" list of *all* buffer numbers
	let l:buffers = []
	for i in range(1, bufnr('$'))
		if bufexists(i)
			call add(l:buffers, i)
		endif
	endfor

	" what tab page are we in?
	let l:currentTab = tabpagenr()
	try
		" go through all tab pages
		let l:tab = 0
		while l:tab < tabpagenr('$')
			let l:tab += 1
			execute 'tabnext' l:tab

			" go through all windows
			let l:win = 0
			while l:win < winnr('$')
				let l:win += 1
				" whatever buffer is in this window in this tab, remove it from
				" l:buffers list
				let l:thisbuf = winbufnr(l:win)
				call remove(l:buffers, index(l:buffers, l:thisbuf))
			endwhile
		endwhile

		" if there are any buffers left, delete them
		if len(l:buffers)
			execute 'bwipeout' join(l:buffers)
		endif
	finally
		" go back to our original tab page
		execute 'tabnext' l:currentTab
	endtry
endfunction
