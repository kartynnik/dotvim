" NeoBundle settings (plugins) {{{1

" NeoBundle plugin manager with initialization {{{2

" Turn off vi compatibility
set nocompatible

" Use NeoBundle for plugin management
" (separate plugins live in private folders under ~/.vim/bundles)
" Should be called before "filetype *": manually add NeoBundle to the runtime path
set runtimepath+=~/.vim/bundle/neobundle.vim/

" List NeoBundle bundles
call neobundle#begin(expand('~/.vim/bundle/'))

" A flag to indicate YouCompleteMe availability (see below)
" YouCompleteMe requires VIM 7.3.584+ compiled with Python support
let g:_ycm_enabled =
    \ filereadable(expand('~/.want_ycm')) &&
    \ (v:version > 703 || (v:version == 703 && has('patch584'))) &&
    \ has('python')

" Compare bundle cache modification time with .vimrc, skip if up to date
if neobundle#has_fresh_cache()
    NeoBundleLoadCache

else
    " For NeoBundle, 'user/repository' is a shortcut for GitHub repos

    " Use this function to overcome restrictive firewalls (allowing only :80 and :443 connections)
    function! FirewallAwareURL(shortcut)
        return 'ssh://git@ssh.github.com:443/' . a:shortcut . '.git'
    endfunction

    " NeoBundle itself
    " (registers a bundle but doesn't add it to the runtime path as we've done it manually before)
    NeoBundleFetch FirewallAwareURL('Shougo/neobundle.vim')

    " A shortcut
    command! -nargs=1 NeoBundleSafe :NeoBundle FirewallAwareURL("<args>")

" }}}

" Color schemes {{{2

    " Mustang
    NeoBundleSafe 'croaker/mustang-vim'

" }}}

" Libraries - the plugins used by other plugins {{{2

    " Asynchronous execution library for Vim (used e.g. by NeoBundle to parallelize updates)
    NeoBundle FirewallAwareURL('Shougo/vimproc.vim'), {
            \ 'build': {
            \     'mac': 'make -f make_mac.mak',
            \     'linux': 'make',
            \     'unix': 'gmake',
            \    },
            \ }

    " Allows to repeat the plugin mappings with "." in the normal mode
    NeoBundleSafe 'tpope/vim-repeat'

" New text objects (like "the right hand side of =" or "a camel case word") {{{2

    " Enables <Leader>w... for moving around CamelCase word parts
    NeoBundleSafe 'bkad/CamelCaseMotion'

    " Makes H a text object for the LHS of an expression (=, ==, =>) and L for the RHS,
    " try e.g. ciL in "stri|ng a = 'some string';"
    NeoBundleSafe 'vim-scripts/text-object-left-and-right'

    " Text objects for surrounding brackets, tags... (:help surround.txt)
    NeoBundleSafe 'tpope/vim-surround'

" Editing experience enhancements {{{2

    " Move and jump to elements of comma-separated lists (e.g. arguments)
    NeoBundleSafe 'AndrewRadev/sideways.vim'

    " Automatic alignment
    " (e.g. around =, try <Enter> in visual mode, :help easy-align)
    NeoBundleSafe 'junegunn/vim-easy-align'

    " Split argument list to multiple lines
    " (binded to <Leader>a in this .vimrc, :help argumentrewrap-examples)
    NeoBundleSafe 'jakobwesthoff/argumentrewrap'

    " Abbreviation and substitution of many word variants at once (:help abolish)
    " + case coercion (try crm on some_word, :help abolish-coerce)
    NeoBundleSafe 'tpope/vim-abolish'

    " Enables <Leader>m to mark all the occurences of a word with a new color,
    " <Leader>r to mark by a regular expression specified, <Leader>n to clear the marks,
    " and allows to jump to the next/previous mark occurences with */# (:help mark.txt)
    NeoBundleSafe 'vim-scripts/Mark--Karkat'

    " Highlight pairs of matching parentheses in distinct colors
    NeoBundleSafe 'kien/rainbow_parentheses.vim'

    " SublimeText-like multiple cursors with Ctrl-N (:help vim-multiple-cursors.txt)
    NeoBundleSafe 'terryma/vim-multiple-cursors'

" Interface enhancements {{{2

    " Many paired commands
    " (like [on, ]on, con to enable/disable/toggle numbering, :help unimpaired)
    NeoBundleSafe 'tpope/vim-unimpaired'

    " Mini buffer explorer (mapped to <Leader>x)
    NeoBundleSafe 'fholgado/minibufexpl.vim'

    " Extended status line
    NeoBundleSafe 'bling/vim-airline'

    " Undo tree (mapped to <Leader>u)
    if (v:version >= 703)
        NeoBundleSafe 'sjl/gundo.vim'
    endif

" Bridges for other tools (UNIX, git, ack...) {{{2

    " Allow to open terminal sessions in buffers
    NeoBundleSafe 'pthrasher/conqueterm-vim'

    " Vim sugar for the UNIX shell commands
    " (:Rename, :SudoWrite, :Chmod, :Locate... - :help eunuch-commands)
    NeoBundleSafe 'tpope/vim-eunuch'

    " Git management (:help fugitive.txt)
    NeoBundleSafe 'tpope/vim-fugitive'
    " Gitk-like repository history
    NeoBundleSafe 'gregsexton/gitv'

    " Ack interface for vim
    NeoBundleSafe 'mileszs/ack.vim'

    if isdirectory(expand('~/.task'))
        " Vim interface for the TaskWarrior command line task manager
        NeoBundleSafe 'farseer90718/vim-taskwarrior'
    endif

" Additional syntax definitions {{{2

" tmux configuration
NeoBundleSafe 'whatyouhide/vim-tmux-syntax'

" IDE features {{{2

" Language-agnostic {{{3
    " File tree
    NeoBundleSafe 'scrooloose/nerdtree'

    " Ctrl-P fuzzy search
    NeoBundleSafe 'kien/ctrlp.vim'
" }}}
" Multiple languages {{{3
    " Autocompletion with <Tab>, clang-based for C-like languages
    if g:_ycm_enabled
        NeoBundle FirewallAwareURL('Valloric/YouCompleteMe'), {
             \ 'build' : {
             \     'mac' : './install.sh --clang-completer',
             \     'linux' : './install.sh --clang-completer',
             \     'unix' : './install.sh --clang-completer',
             \    }
             \ }
    endif

    " Syntax error highlighting
    NeoBundleSafe 'scrooloose/syntastic'

    " Code snippets support
    NeoBundleSafe 'SirVer/ultisnips'
    " A bunch of predefined snippets for UltiSnips
    NeoBundleSafe 'honza/vim-snippets'

    " Commenting with gc*
    NeoBundleSafe 'tpope/vim-commentary'
" }}}
" C/C++ {{{3
    " #include completion
    NeoBundleSafe 'xaizek/vim-inccomplete'
" }}}
" Python {{{3
    " Python IDE and editor enhancement features
    " (motion, syntax checking, refactoring, documentation, breakpoints on <Leader>b, :help pymode)
    NeoBundleSafe 'klen/python-mode'

    " Python autocompletion (YouCompleteMe includes its features)
    if ! g:_ycm_enabled
        NeoBundleSafe 'davidhalter/jedi-vim'
    endif

    " Resolve Python modules on gf (go to file)
    NeoBundleSafe 'mkomitee/vim-gf-python'
" }}}
" Jade templates {{{3
    " Jade syntax plugin
    NeoBundleSafe 'digitaltoad/vim-jade.git'
" }}}2

" NeoBundle initialization finish {{{2

    " Save bundle cache
    NeoBundleSaveCache
endif

" Finalize NeoBundle initialization
call neobundle#end()

" Let YouComleteMe install in time
let g:neobundle#install_process_timeout = 3000

" Check that all NeoBundle plugins are installed
NeoBundleCheck

" }}}

" Environment check {{{1
if ! has('ex_extra')
    echoerr 'This version of VIM is compiled in "small" or "tiny" configuration, so the .vimrc uses many unsupported features'
endif


" Display setup {{{1

" Enable syntax highlighting,
" override color settings with defaults
syntax on
" Enable filetype syntax plugin and
" indentation plugin loading
" after enabling filetype support
filetype plugin indent on


" Enable 256 colors
set t_Co=256

" Background and color scheme
set background=dark
if &t_Co >= 256 || has('gui_running')
    colorscheme mustang
endif

" Prevent $VIMRUNTIME/syntax/synload.vim from issuing :colors
" when .vimrc is reloaded
if exists("colors_name")
    unlet colors_name
endif

" Set terminal title
if has('title')
    set title
    " Change to the host:filename.ext pattern
    autocmd BufEnter * let &titlestring = hostname() . ':' . expand("%:t")
    " Upon existing, change to just hostname
    let &titleold = hostname()
endif

" Fast terminal connection - smoother redrawing
set ttyfast

" Don't wrap long lines
set nowrap
" Except in diff mode
autocmd FilterWritePre * if &diff | setlocal wrap | endif

" Show this amount of text around cursor
set scrolloff=3

" Show cursor position and percentage
set ruler
" Show line numbers
set number
" Show relative line numbers
" if (v:version >= 703)
"     set relativenumber
" endif

" Show matching bracket
set showmatch

" Delphi-like 'last column'
set colorcolumn=120
highlight ColorColumn ctermbg=235

" Always show status line
set laststatus=2

" Show currently typed command in lower right corner
set showcmd

" Enable mouse in all modes
" set mouse+=a

" DONT_COMMIT is highlighted in red
function! SetupDontCommit()
    syntax match dontCommit /DONT_COMMIT/
    " Comments usually contain @Spell cluster
    syntax cluster Spell add=dontCommit
    highlight dontCommit ctermbg=red guibg=red
endfunction
autocmd Syntax * call SetupDontCommit()


" Windows and tabs {{{1

" When switching to files...
" ...use open windows {..and tabs, open a new tab if the file is not open}
" [...split a window]
set switchbuf=useopen " {,usetab,newtab} [,split]

" Tab hotkeys
" map <C-N> :tabnew<CR>:edit<Space>
map <silent> <Leader>c :call MyLastTabClose()<CR>
function! MyLastTabClose()
    if tabpagenr('$') == 1
        quit
    else
        tabclose
    endif
endfunction

" Allow to close the last window
function! MyLastWindowClose()
    if winnr('$') == 1
        quit
    else
        close
    endif
endfunction

" http://vim.wikia.com/wiki/Automatically_quit_Vim_if_quickfix_window_is_the_last
function! MyLastWindow()
    if &buftype == "quickfix"
        if winnr('$') == 1
            quit
        endif
    endif
endfunction
autocmd BufEnter * call MyLastWindow()

" Easy window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Switch to a new vertically split window
nnoremap <Leader>s <C-w>v<C-w>l


" Exit on X
nmap <silent> X :qa<CR>


" Encoding, tabulation and indentation {{{1

" UTF-8 encoding
set enc=utf-8
language en_US.UTF-8

" Enable automatic indentation
set autoindent
" Language-specific autoindenting
set smartindent
" Use spaces instead of tabs
set expandtab
" Tab stops
set tabstop=4
" Number of spaces for autoindent step
set shiftwidth=4
" Allow Tab & Shift-Tab indentation
" in /normal and/ visual modes
vnoremap <Tab> >>
vnoremap <S-Tab> <<
" Show tabs as >---, trailing spaces as _ and non-breakable spaces as ! in gray, see :help listchars
set list
set listchars=tab:>-,trail:_,nbsp:!


" Russian support (switching via Ctrl-^) {{{1

set keymap=russian-jcukenwin
" Reset lmap (language mappings) to off by default
set iminsert=0
set imsearch=0
" Show a different cursor in GUI for lmap'ped mode
highlight lCursor guifg=NONE guibg=Cyan
" Avoid issues with ё on spelling
" :setlocal spell spelllang=ru_yo,en_us


" C++ indentation: place scope declarations
" like public: at the beginning of the line [g0]
" Open braces indentation: add only one shiftwidth
" after an unclosed ( in previous line [(1s]
set cinoptions=g0,(1s


" Python indentation
autocmd FileType python set cindent
" Indent after an open parenthesis
let g:pyindent_open_paren = '&shiftwidth'
" Indent after a nested parenthesis
let g:pyindent_nested_paren = '&shiftwidth'
" Indent for a continuation line
let g:pyindent_continue = '&shiftwidth'

" Auto remove spaces at ends of lines
autocmd BufWritePre *.{c,cc,cxx,cpp,h,py} :%s/\s\+$//e


" Basic mappings {{{1

" Set Leader to comma
let mapleader = ","


" jj is faster than <ESC>
inoremap jj <ESC>
" jk is better than <ESC>
inoremap jk <ESC>
" See LMap() below that disables them in lmap'ped mode
" Be evil - breaks Del, Ins, arrows etc. too
" inoremap <ESC> <Nop>

" <Space> + character = insert one character
nmap <silent> <Space> :execute "normal i" . nr2char(getchar())<CR>

" Use gj/gk by default
nnoremap j gj
nnoremap k gk

" Use ; as :
" nnoremap ; :

" <Leader>o - like Ctrl-O, but jump directly to the previous buffer
function! JumpToPreviousBuffer()
    let startingBuffer = bufname('%')
    let startingPos = getpos('.')
    while 1
        execute "normal! \<C-o>"
        if bufname('%') != startingBuffer
            break
        end
        if getpos('.') == startingPos
            " No previous buffer
            break
        endif
    endwhile
endfunction
nmap <silent> <Leader>o :call JumpToPreviousBuffer()<CR>


" Filesystem {{{1

" Auto change directory
set autochdir

" When a file is changed outside with no local modifications, reload it
set autoread

" Auto write on some commands, e.g. make
set autowrite

" Do not create swap files
" set noswapfile
" Directories for swap files
set dir=/var/tmp,/tmp

" Do not create a backup and do not call fsync() on writes
" Dangerous, but helps fighting hangs on :w
set nofsync
set nowritebackup

" Confirm unsaved changes, read-only writes etc.
set confirm

" Use terminal code to display visual bell (probably screen flash) instead of a beep
" set visualbell

" Hide modified buffer when moving to another
set hidden


" Show current file path
nnoremap <silent> <Leader>: :echo expand("%:p")<CR>

" Go to .proto on gf instead of .pb.h
:set includeexpr=substitute(v:fname,'\\.pb\\.h$','.proto','')

" gf will create an unexisting file, see :help gf and :help <cfile>
function! FindOrCreateCurrentFile()
    let curfile = expand("%:p")
    let thatfile = expand("<cfile>:p")
    silent! normal! gf
    let nowfile = expand("%:p")
    if nowfile == curfile
        execute "edit " . thatfile
    endif
endfunction
nnoremap <silent> gf :call FindOrCreateCurrentFile()<CR>


" Allow to switch source/header
function! SwitchSourceHeader()
    " %:e stands for "current file extension"
    let extension = expand("%:e")
    " %:t:r stands for "current file path without the extension"
    if (extension == "cpp" || extension == "cc" || extension == "c")
        try
            " tabfind %:t:r.h
            find %:t:r.h
        " Can't find file "..." in path
        catch /E345/
        endtry
    else
        try
            " tabfind %:t:r.cpp
            find %:t:r.cpp
        " Can't find file "..." in path
        catch /E345/
            try
                find %:t:r.cc
            catch /E345/
                try
                    find %:t:r.c
                catch /E345/
                endtry
            endtry
        endtry
    endif
endfunction
nmap <silent> gs :call SwitchSourceHeader()<CR>


" Tell vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
" %    :  saves and restores the buffer list
" !    :  saves global variables (for the Mark--Karkat plugin)
" n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,!,n~/.viminfo

" Yank/paste between vim sessions (via .viminfo - with the corresponding side effects)
vmap <silent> <leader>y "xy:wviminfo!<CR>
nmap <silent> <leader>Y "xY:wviminfo!<CR>
nmap <silent> <leader>p :rviminfo!<CR>"xp
nmap <silent> <leader>P :rviminfo!<CR>"xP


" Editing {{{1

" Allow backspacing over autoindent,
" EOL, start of insert
set backspace=indent,eol,start

" Allow moving cursor after EOLs
" and inside TABs
set virtualedit=all

" The key that toggles paste mode, see also yo and yO in vim-unimpaired
set pastetoggle=<C-S-F12>

" Reselect the text that was just pasted
nnoremap <Leader>v V']

" https://gist.github.com/DelvarWorld/048616a2e3f5d1b5a9ad
function! Refactor()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction

" Locally (local to block) rename a variable
" Copy inner word to 'z' named register, call Refactor() that modifies it, set mark 'x',
" go to definition, go to previous unmatched '{', select all lines down to the pairing '}',
" replace every occurence of the last search with the contents of the 'z' named register, return to mark 'x'
nmap <silent> <Leader>rf "zyiw:call Refactor()<CR>mx:silent! normal gd<CR>[{V%:s/<C-R>//<C-R>z/<CR>`x


" Open .vimrc
nnoremap <silent> <Leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
" Open .bashrc
nnoremap <silent> <Leader>eb <C-w><C-v><C-l>:e ~/.bashrc<CR>

" Source .vimrc upon closing
autocmd! BufWritePost .vimrc nested source %


" Search {{{1

" Ignore case in search strings
set ignorecase
" ...unless they have upper case chars
set smartcase
" Highlight search results
set hlsearch
" Incremental search (as you type)
set incsearch
" Wrap-around search
set wrapscan
" Select Perl-compatible regexes by default ("very magic")
nnoremap / /\v
vnoremap / /\v
" Search globally by default, g switches back
set gdefault
" Clear search highlighting
nnoremap <silent> <Leader><space> :noh<CR>


" Make and quickfix {{{1

" Various make programs
" %:r stands for "current file path without the extension"
command! GCC set makeprg=g++\ -O3\ -o\ %:p:r\ %
command! Make set makeprg=make\ -j${cores:-16}
command! YaBuild set makeprg=ya\ build\ -j${cores:-16}\ -r
command! Check set makeprg=check
command! UT set noautochdir | cd ut | set makeprg+=&&./*-ut

" Make with g++, make or ya build
GCC
if filereadable("Makefile")
    Make
elseif filereadable("CMakeLists.txt")
    YaBuild
endif

" Check syntax using check
function! CheckSyntax()
    let oldmakeprg = &makeprg
    Check
    silent make
    redraw!
    let &makeprg = oldmakeprg
endfunction
" Save and check syntax
" nnoremap <silent> <Leader>s :call CheckSyntax()<CR>

" Make (and jump to the first error - :cfirst<CR>)
map <C-F5> :make<CR>
" Don't treat 'In file included from <path>' as a file name
set errorformat^=%-GIn\ file\ included\ %.%#
" Wrap quickfix window contents
autocmd FileType qf setlocal wrap linebreak

" http://vim.wikia.com/wiki/Automatically_open_the_quickfix_window_on_:make
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Add current file's, current {and all subdirectories} to the path
set path=., " {,**} - doesn't play well with inccomplete.vim and makes not much sense
" Add source root to the path
set path+=$root,$root/../build/release

" List possible tags locations
" set tags=tags\ ../tags\ ../../tags

" Run current file
nnoremap <silent> <Leader><Leader> :!./%<CR>


" Completion {{{1

" Complete options (disable preview scratch window) {only insert the longest common prefix}
set completeopt=menu,menuone " {,longest}
" Limit popup menu height
set pumheight=15
" Show menu on multiple options
set wildmenu
set wildmode=list:longest


" Disable jj/jk (see above) in lmap'ped mode for "сообщать" and "положить"
function! LMap()
    if &iminsert == 1
        set iminsert=0
        inoremap jj <ESC>
        inoremap jk <ESC>
        " imap <ESC> <Nop>
    else
        set iminsert=1
        iunmap jj
        iunmap jk
        " iunmap <ESC>
    endif
    call feedkeys('a')
endfunction
inoremap <silent> <C-^> <ESC>:call LMap()<CR>



" Plugin settings and mappings {{{1

" Mini Buffer Explorer
" Disable autostart
let g:miniBufExplAutoStart = 0
" Toggle MiniBufExplorer
nnoremap <silent> <Leader>x :MBEToggleAll<CR>

" NERDTree (filesystem tree) {{{2
" Toggle NERDTree
nnoremap <silent> <Leader>T :NERDTreeToggle<CR>
" Draw pretty arrows in the tree
let NERDTreeDirArrows=1
" Close vim if NERDTree is the last window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open source root in NERDTree
nnoremap <silent> <Leader>A :NERDTree $root<CR>
" Autoopen NERDTree if no files were specified on command line, but switch to the new file window
" autocmd vimenter * if !argc() | NERDTree | call feedkeys("\<C-w>l") | endif

" Gundo - undo tree (requires Vim 7.3) {{{2
" Toggle Gundo
nnoremap <silent> <Leader>u :GundoToggle<CR>

" Inccomplete - autocomplete #includes {{{2
" In the inccomplete plugin, show directories too
let g:inccomplete_showdirs = 1
" Append slash to directories
let g:inccomplete_appendslash = 1
" Use 'find'
" let g:inccomplete_findcmd = 'find'

" Airline - status line {{{2
" Show fancy unicode symbols (needs an ovelapping or a patched font on the client side, see
"   http://powerline.readthedocs.org/en/latest/installation/linux.html)
" let g:airline_powerline_fonts = 1
" Theme setup
let g:airline_theme = 'powerlineish'
" Whitespace errors check slows down loading of large files
let g:airline#extensions#whitespace#max_lines = 2000

" Ctrl-P - fuzzy finder {{{2
" For large directories, use .allfiles instead of find in Ctrl-P
" let g:ctrlp_user_command = 'listfiles.sh %s'
" Use Ctrl-P in mixed files/buffers/MRU mode
let g:ctrlp_cmd = 'CtrlPMixed'
" Use only the directory of current file in file mode
let g:ctrlp_working_path_mode = 'c'

" Syntastic - syntax checker {{{2
" Use custom script for syntastic
let g:syntastic_cpp_compiler = 'check'
" Do not search for headers of special libraries
let g:syntastic_cpp_no_include_search = 1
" Do not use default includes
let g:syntastic_cpp_no_default_include_dirs = 1
" Do not check on exit-triggered writes
let g:syntastic_check_on_wq = 0
" ...and on all writes (use :SyntasticCheck and :SyntasticToggleMode)
let g:syntastic_mode_map = { "mode": "passive" }
" Save and check syntax
if g:_ycm_enabled != 1
    nnoremap <silent> <Leader>s :w<CR>:SyntasticCheck<CR>
endif

" YouCompleteMe - autocompletion {{{2
if g:_ycm_enabled == 1
    " Fallback file with flags
    let g:ycm_global_ycm_extra_conf = expand('~/.repo/.ycm_extra_conf.py')
    " Whitelisted flag files
    python import os.path
    let g:ycm_extra_conf_globlist = [
        \ pyeval('os.path.realpath(os.path.expanduser("~/.ycm_extra_conf.py"))'),
        \ pyeval('os.path.realpath(os.path.expandvars("$root/.ycm_extra_conf.py"))')
    \ ]
    nnoremap <silent> <Leader>s :w<CR>:YcmDiags<CR>
    " Add the preview string to completeop so that the completion preview window becomes available
    let g:ycm_add_preview_to_completeopt = 1
    " Do not trigger as-you-go completion
    " let g:ycm_min_num_of_chars_for_completion = 100500
    " Go to definition/declaration
    nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
endif

" EasyAlign - text alignment {{{2
" Activate interactive mode
vmap <Enter> <Plug>(EasyAlign)

" ArgumentRewrap - split argument list to multiple lines {{{2
" Activate
nnoremap <silent> <Leader>a :call argumentrewrap#RewrapArguments()<CR>

" ConqueTerm - terminal inside Vim {{{2
" Open terminal
nnoremap <Leader>t :ConqueTermSplit bash<CR>
" Open Python
nnoremap <Leader>py :ConqueTermSplit python<CR>

" Rainbow parentheses - show pairs of matching parentheses in different colors {{{2
if isdirectory(expand('~/.vim/bundle/rainbow_parentheses.vim'))
    " Enable automatically
    autocmd VimEnter * RainbowParenthesesToggle
    autocmd Syntax * RainbowParenthesesLoadRound
    autocmd Syntax * RainbowParenthesesLoadSquare
    autocmd Syntax * RainbowParenthesesLoadBraces
    " Colors used for bracket pairs
    let g:rbpt_colorpairs = [
        \ ['darkblue',    'SeaGreen3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkmagenta', 'DarkOrchid3'],
    \ ]
endif

" Vim-gf-python - python-aware gf
" Extend sys.path for python gf plugin
function! PythonPath(...)
    for path in a:000
        python import os, vim, sys; sys.path.append(vim.eval('expand(path)'))
    endfor
endfunction
command! -nargs=+ PythonPath call PythonPath(<args>)

" Python-Mode - Python IDE features {{{2
" Maximum line width
let g:pymode_options_max_line_length = &colorcolumn - 1
" Show docstring
let g:pymode_rope_show_doc_bind = '<Leader>d'
" Go to definition
let g:pymode_rope_goto_definition_bind = 'gd'
" Command to execute when a definition has been found
let g:pymode_rope_goto_definition_cmd = 'e'
" Offer to import unresolved objects after completion
let g:pymode_rope_autoimport_import_after_complete = 1
" Disable Rope autocompletion in favour of jedi-vim
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
" Use PymodeLint instead of SyntasticCheck for Python
autocmd FileType python nnoremap <buffer> <silent> <Leader>s :w<CR>:PymodeLint<CR>

" Jedi-vim - Python autocompletion {{{2
" Disable choose first function/method on autocomplete
let g:jedi#popup_select_first = 0

" UltiSnips - Code snippets
" Mappings not conflicting with YouCompleteMe
let g:UltiSnipsExpandTrigger="<NL>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"

" VIM-TaskWarrior - TaskWarrior command-line task manager VIM interface {{{2
" Open TaskWarrior 'task next' report
nmap T :TW<CR>
" Clear filters (Ctrl-U clears the line in Insert mode)
autocmd FileType taskreport nmap <buffer> F <Plug>(taskwarrior_filter)<C-U><CR>
" Merge with remote location
autocmd FileType taskreport nmap <buffer> <Leader>m :TW merge<CR>
" Modify task priority
autocmd FileType taskreport nmap <buffer> P <Plug>(taskwarrior_command)mod pri:
" Include own reports into the report list
function! TaskWarriorAddOwnReports()
    for report in ['byproject']
        if index(g:task_report_command, report) == -1
            let g:task_report_command += [report]
        endif
    endfor
endfunction
autocmd FileType taskreport call TaskWarriorAddOwnReports()
" Clear defaults (with Ctrl-U) when asking for a report name
autocmd FileType taskreport nmap <buffer> r <Plug>(taskwarrior_report)<C-U>
" Default fields to ask when adding a new task
let g:task_default_prompt = ['project', 'description', 'priority']
" .taskrc overrides
let g:task_rc_override = 'rc.defaultwidth=0 rc.defaultheight=0'

" Sideways - move and jump to elements of comma-separated lists (e.g. arguments)
nnoremap <silent> <Leader>h :SidewaysLeft<CR>
nnoremap <silent> <Leader>l :SidewaysRight<CR>


" Local machine-specific .vimrc {{{1

" Execute ~/.specifics.vim {{{2
if filereadable(expand('~/.specifics.vim'))
    execute 'source ~/.specifics.vim'
endif

" Vim folding for this file {{{1
" vim: set foldmethod=marker:
