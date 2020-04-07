" Dein settings (plugins) {{{1

" Flags for enabling/disabling certain plugins {{{2

" A flag indicating that we are running under the "Neo Vim" VSCode extension
let g:_vscode = exists('g:vscode')
" A flag to indicate that only plugins for embedded NeoVim should be loaded
let g:_embedded = g:_vscode

" A flag to indicate availability and desirability of YouCompleteMe (see below)
let g:_ycm_enabled = filereadable(expand('~/.want_ycm'))

" A flag to indicate desirability of Python-mode (see below)
let g:_pymode_enabled = filereadable(expand('~/.want_pymode'))

" A flag to indicate desirability of Jedi-Vim (see below)
let g:_jedi_enabled = filereadable(expand('~/.want_jedi'))

" Dein.vim requires at least Vim 7.4
let g:_dein_minimum_vim_version = 704


" Dein plugin manager with initialization {{{2

" Turn off vi compatibility
set nocompatible

" Workaround for https://github.com/vim/vim/issues/3117
if !has('nvim') && !has('patch-8.1.201') && has('python3')
    silent! python3 0
endif

if v:version >= g:_dein_minimum_vim_version
    " Use Dein for plugin management
    " (separate plugins live in private folders under ~/.vim/bundle/repos)
    " Should be called before "filetype *": manually add Dein to the runtime path
    set runtimepath+=~/.vim/bundle/repos/github.com/Shougo/dein.vim/

    " NeoVim compatibility
    let g:_editor_home = has('nvim') ? '~/.config/nvim' : '~/.vim'
    let g:_bundle_home = g:_editor_home . '/bundle/'

    " Use shallow repository clones
    let g:dein#types#git#clone_depth = 1

    " Compare bundle cache modification time with .vimrc, skip if up to date
    if dein#load_state(g:_bundle_home)

        " List Dein bundles
        call dein#begin(expand(g:_bundle_home))

        " For Dein, 'user/repository' is a shortcut for GitHub repos

        " Dein itself
        call dein#add('Shougo/dein.vim')

        " A shortcut for plugins that are loaded for any environment
        command! -nargs=1 Plugin call dein#add(<args>)

        " A shortcut for plugins that are loaded only in VSCode "Neo Vim" plugin
        command! -nargs=1 PluginVSCode call dein#add(<args>, {'if': g:_vscode})

        " A shortcut for plugins that are not loaded in embedded NeoVim
        command! -nargs=1 PluginFull call dein#add(<args>, {'if': !g:_embedded})

" Color schemes {{{2

        " Mustang
        PluginFull 'croaker/mustang-vim'

        " Janah
        PluginFull 'mhinz/vim-janah'

" Libraries - the plugins used by other plugins {{{2
        " Allows to repeat the plugin mappings with "." in the normal mode
        Plugin 'tpope/vim-repeat'

        " Allows to define new text objects, see the examples at https://github.com/kana/vim-textobj-user/wiki
        Plugin 'kana/vim-textobj-user'

" New text objects (like "the right hand side of =" or "a camel case word component") {{{2

        " Enables <Leader>w... for moving around CamelCase / snake_case etc. word parts
        Plugin 'chaoren/vim-wordmotion'

        " Makes H a text object for the LHS of an expression (=, ==, =>) and L for the RHS,
        " try e.g. ciL in "stri|ng a = 'some string';"
        Plugin 'vim-scripts/text-object-left-and-right'

        " Text objects for surrounding brackets, tags... (:help surround.txt)
        Plugin 'tpope/vim-surround'

" Editing experience enhancements {{{2
        " Access various alternate clipboards even if `+clipboard` is missing
        PluginFull "kana/vim-fakeclip"

        " Visually select increasingly larger regions of text with + (shrink with _)
        Plugin 'terryma/vim-expand-region'

        " Extended % matching for HTML, LaTeX, ...
        Plugin 'tmhedberg/matchit'

        " For modern terminals, frees from the need to :set paste / :set nopaste
        PluginFull 'ConradIrwin/vim-bracketed-paste'

        " Move and jump to elements of comma-separated lists (e.g. function arguments)
        Plugin 'AndrewRadev/sideways.vim'

        " Automatic alignment
        " (e.g. columns of "=" signs; try <Enter> in visual mode; :help easy-align)
        Plugin 'junegunn/vim-easy-align'

        " Abbreviation and substitution of many word variants at once (:help abolish)
        " + case coercion (try crm on some_word, :help abolish-coerce)
        Plugin 'tpope/vim-abolish'

        " Enables <Leader>m to mark all the occurences of a word with a new color,
        " <Leader>r to mark by a regular expression specified, <Leader>n to clear the marks,
        " and allows to jump to the next/previous mark occurences with */# (:help mark.txt)
        Plugin 'vim-scripts/Mark--Karkat'

        " Highlight pairs of matching parentheses in distinct colors
        Plugin 'luochen1990/rainbow'

        " SublimeText-like multiple cursors with Ctrl-N (:help vim-multiple-cursors.txt)
        PluginFull 'terryma/vim-multiple-cursors'

        " Vimperator/Vimium-style jumping to remote parts by appearing highlighted keys,
        " e.g. <Leader><Leader>w followed by t to jump to the word with the key t like <number>w would
        PluginFull 'easymotion/vim-easymotion'
        PluginVSCode 'asvetliakov/vim-easymotion'

" Interface enhancements {{{2

        " Adds a diff option when Vim finds a swap file
        PluginFull 'chrisbra/Recover.vim'

        " A fancy tart screen
        PluginFull 'mhinz/vim-startify'

        " Smooth scrolling
        PluginFull 'yuttie/comfortable-motion.vim'

        " Indentation markers
        PluginFull 'Yggdroot/indentLine'

        " Many paired commands
        " (like [on, ]on, con / [ow, ]ow, cow to enable/disable/toggle line numbering/wrapping, :help unimpaired)
        Plugin 'tpope/vim-unimpaired'

        " Mini buffer explorer (mapped to <Leader>x)
        PluginFull 'fholgado/minibufexpl.vim'

        " Extended status line
        PluginFull 'vim-airline/vim-airline'
        PluginFull 'vim-airline/vim-airline-themes'

        " Undo tree (mapped to <Leader>u)
        if has('nvim') || v:version >= 703
            PluginFull 'sjl/gundo.vim'
        endif

        " Allows to build diffs with better algorithms (requires git-diff)
        PluginFull 'chrisbra/vim-diff-enhanced'

        " Make the yanked region apparent
        Plugin 'machakann/vim-highlightedyank'

" Bridges for other tools (UNIX, git, ack/ripgrep...) {{{2

        if !has('nvim') && !has('terminal')
            " Allows to open terminal sessions in buffers
            " (superseded by NeoVim / Vim 8+ native terminal support)
            PluginFull 'pthrasher/conqueterm-vim'
        endif

        " Vim sugar for the UNIX shell commands
        " (:Rename, :SudoWrite, :Chmod, :Locate... - :help eunuch-commands)
        PluginFull 'tpope/vim-eunuch'

        " Git management (:help fugitive.txt)
        PluginFull 'tpope/vim-fugitive'
        " Gitk-like repository history
        PluginFull 'gregsexton/gitv'

        " VCS diff in the gutter
        PluginFull 'mhinz/vim-signify'

        " An Ack interface for Vim (using it with ripgrep if available)
        PluginFull 'mileszs/ack.vim'

        if isdirectory(expand('~/.task'))
            " Vim interface for the TaskWarrior command line task manager
            PluginFull 'farseer90718/vim-taskwarrior'
        endif

        " Execute shell commands in the buffer
        PluginFull 'JarrodCTaylor/vim-shell-executor'

" IDE features {{{2

" Language-agnostic {{{3

        " Filesystem tree
        PluginFull 'scrooloose/nerdtree'

        " Ctrl-P fuzzy filename search
        PluginFull 'kien/ctrlp.vim'

        " Allow for per-project settings in the .local.vimrc file of the project root
        Plugin 'thinca/vim-localrc'

        " Auto-detect indentation options based on current or other similar files
        Plugin 'tpope/vim-sleuth'

        " :Make in a screen/tmux/iTerm/cmd.exe... spinoff with a quickfix window opened afterwards;
        " :Make! for background, and more: see https://github.com/tpope/vim-dispatch
        PluginFull 'tpope/vim-dispatch'

        " QuickRun - execute whole/part of the edited file
        PluginFull 'thinca/vim-quickrun'

" Multiple languages {{{3
        " Autocompletion with <Tab>, clang-based for C-like languages
        if g:_ycm_enabled && (has('python') || has('python3'))
            call dein#add('Valloric/YouCompleteMe', {
                \ 'on_ft': ['c', 'cpp', 'python', 'objcpp'],
                \ 'timeout': 3600,
                \ 'build': './install.sh --clang-completer',
                \ 'if': !g:_embedded})
        endif

        " Syntax error highlighting
        PluginFull 'scrooloose/syntastic'

        if has('python3')
            " Code snippets support
            PluginFull 'SirVer/ultisnips'

            " A bunch of predefined snippets for UltiSnips
            PluginFull 'honza/vim-snippets'
        endif

        " Commenting with gc*
        Plugin 'tpope/vim-commentary'

        " All-in-one programming language pack
        PluginFull 'sheerun/vim-polyglot'

        " Switch between a single-line statement and a multi-line one (gJ / gS)
        Plugin 'AndrewRadev/splitjoin.vim'

" C/C++ {{{3
        " #include completion
        PluginFull 'xaizek/vim-inccomplete'

" Python {{{3
        " Python IDE and editor enhancement features
        " (motion, syntax checking, refactoring, documentation, breakpoints on <Leader>b, :help pymode)
        if g:_pymode_enabled
          PluginFull 'python-mode/python-mode'
        endif

        " Python autocompletion (YouCompleteMe includes its features)
        if g:_jedi_enabled && ! g:_ycm_enabled && (has('python') || has('python3'))
            PluginFull 'davidhalter/jedi-vim'
        endif

        " "A class"/"inner class", "a function"/"inner function" text objects + class/function motions
        Plugin 'bps/vim-textobj-python'

" TeX/LaTeX {{{3
        " Live preview
        PluginFull 'xuhdev/vim-latex-live-preview'

" Dein initialization finish {{{2

        " Finalize Dein initialization
        call dein#end()

        " Save bundle cache
        call dein#save_state()
    endif

    " Check that all the Dein plugins are installed
    if dein#check_install()
        call dein#install()
    endif

endif

" Environment check {{{1
if ! has('ex_extra') && ! has('nvim')
    echoerr 'This version of Vim is compiled in a "small" or "tiny" configuration, ' .
        \ 'so the .vimrc file is using many unsupported features'
endif


" Display setup {{{1

" GUI font and control visibility options
if has('gui_running')
    " Some of the GUI options (notably M) need to be set before syntax/filetype
    " A minimalist setup (much like a console Vim):
    " "a" - autoselect (use X clipboard with visual selections)
    " "c" - use console dialogs instead of GUI pop-ups
    " "M" - don't source menu.vim
    set guioptions=acM
endif


" Enable syntax highlighting, override color settings with the defaults
syntax on
" Enable filetype syntax plugin and indentation plugin loading after enabling filetype support
filetype plugin indent on


" Enable 256 colors support
set t_Co=256

" Background and color scheme
set background=dark
if &t_Co >= 256 || has('gui_running')
    try
        " colorscheme mustang

        autocmd ColorScheme janah highlight Normal ctermbg=232
        autocmd ColorScheme janah highlight Comment ctermfg=245
        autocmd ColorScheme janah highlight Search ctermbg=27
        colorscheme janah
    catch /E185:/
        " Color scheme not (yet) installed
        colorscheme desert
    endtry
endif

" Prevent $VIMRUNTIME/syntax/synload.vim from issuing :colors when .vimrc is reloaded
if exists('colors_name')
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

" Don't wrap long lines by default (use "cow" mapping from vim-unimpaired to toggle)
set nowrap
" ...except in diff mode
autocmd FilterWritePre * if &diff | setlocal wrap | endif
" When wrapping, use `breakat` (by default whitespace/punctuation), not just anything
set linebreak
" Display as much as possible of the last line instead of '@'s
set display=lastline

" Show this amount of text around cursor
set scrolloff=3

" Show cursor position and percentage
set ruler
" Show line numbers
set number
" ...except in the terminal
if has('nvim')
  autocmd TermOpen * setlocal nonumber norelativenumber
else
  autocmd TerminalOpen * setlocal nonumber norelativenumber
endif
" Show relative line numbers
" if (v:version >= 703)
"     set relativenumber
" endif

" Highlight matching brackets
set showmatch
" Include angle brackets in bracket matching
setglobal matchpairs+=<:>

" Don't attempt syntax highlighting after this column (performance)
set synmaxcol=200

" Delphi-like highlighted 'last column'
try
    set colorcolumn=120
catch
endtry
highlight ColorColumn ctermbg=235

" Always show the status line
set laststatus=2

" Show the currently typed command in lower right corner
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
" ...use open windows {..and tabs, open a new tab if the file is not open} [...split a window]
set switchbuf=useopen " {,usetab,newtab} [,split]

" Tab hotkeys
" Close the current tab; exit if it was the last one
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

" Use UTF-8 encoding internally
set encoding=utf-8
try
    language en_US.UTF-8
catch
endtry

" Try these encodings in order when opening a file
set fileencodings=ucs-bom,utf-8,windows-1251

" Do not automatically wrap lines in text files and comments
set textwidth=0

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
" Backspace unindents
set smarttab
" Allow (de-)indenting with Tab & Shift-Tab in visual mode
vnoremap <Tab> >>
vnoremap <S-Tab> <<
" Show tabs as >---, trailing spaces as _ and non-breakable spaces as ! in gray, see :help listchars
set list
set listchars=tab:>-,trail:_,nbsp:!

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif


" Russian keymap support (switching via Ctrl-^, see language-mapping) {{{1

set keymap=russian-jcukenwin
" Reset language mappings to off by default
set iminsert=0
set imsearch=0
" Show a different cursor in GUI for lmap'ped mode
highlight lCursor guifg=NONE guibg=Cyan
" Avoid issues with ё in spelling
" :setlocal spell spelllang=ru_yo,en_us


" C++ indentation: place scope declarations like "public:" at the beginning of the line [g0].
" Open braces indentation: add only one shiftwidth after an unclosed ( in previous line [(1s].
" Switch statements indentation: align with case label, not braces [l1].
set cinoptions=g0,(1s,l1


" Python indentation
autocmd FileType python set cindent
" Indent after an open parenthesis
let g:pyindent_open_paren = '&shiftwidth'
" Indent after a nested parenthesis
let g:pyindent_nested_paren = '&shiftwidth'
" Indent for a continuation line
let g:pyindent_continue = '&shiftwidth'

" Auto-remove spaces at ends of lines
autocmd BufWritePre *.{c,cc,cxx,cpp,h,py} :%s/\s\+$//e


" Basic mappings {{{1

" Set <Leader> to comma
let mapleader = ","


" jj is faster than <ESC>
inoremap jj <ESC>
" jk is even faster
inoremap jk <ESC>
" See LMap() below that disables them in lmap'ped mode

" Be evil - breaks Del, Ins, arrows etc. too - only jj/jk remain for exiting the Insert mode
" inoremap <ESC> <Nop>

" <Space> + character = insert one character
nmap <silent> <Space> :execute "normal i" . nr2char(getchar()) <bar> execute "normal l"<CR>

" Use gj/gk by default (move by visible lines, not logical ones)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

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

" In git mergetool mode, use 1/2/3 to pull changes from LOCAL/BASE/REMOTE
if &diff
    map <Leader>1 :diffget LOCAL<CR>
    map <Leader>2 :diffget BASE<CR>
    map <Leader>3 :diffget REMOTE<CR>
endif


" Filesystem {{{1

" Auto change the current directory to the one the file being edited resides in
try
    set autochdir
catch
endtry

" When a file is changed outside with no local modifications, reload it
set autoread

" Auto-write on some commands, e.g. make
set autowrite

" Do not create swap files
" set noswapfile
" Directories for swap files
set dir=/var/tmp,/tmp

" Do not create a backup and do not call fsync() on writes. Dangerous, but helps fighting hangs on :w.
set nofsync
set nowritebackup

" Auto-confirm unsaved changes, read-only writes etc.
set confirm

" Use terminal code to display a visual bell (most likely a screen flash) instead of a beep
set visualbell
" And then use an empty code to produce the visual bell, i.e. do nothing
set t_vb=

" Hide a modified buffer when moving to another
set hidden


" Show the current file path
nnoremap <silent> <Leader>: :echo expand("%:p")<CR>

" Go to the *.proto file on gf instead of *.pb.h
:set includeexpr=substitute(v:fname,'\\.pb\\.h$','.proto','')

" gf will create a non-existent file, see :help gf and :help <cfile>
function! FindOrCreateCurrentFile()
    let curfile = expand("%:p")
    let thatfile = expand("<cfile>:p")
    silent! normal! gf
    let nowfile = expand("%:p")
    if nowfile == curfile
        execute "edit " . thatfile
    endif
endfunction
if !g:_embedded
    nnoremap <silent> gf :call FindOrCreateCurrentFile()<CR>
endif


" Switch source/header with "gs"
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


" Tell Vim to remember certain things when we exit
" '10  :  marks will be remembered for up to 10 previously edited files
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
" %    :  saves and restores the buffer list
" !    :  saves global variables (for the Mark--Karkat plugin)
set viminfo='10,\"100,:20,%,!

" Yank/paste between Vim sessions (via .viminfo - with the corresponding side effects)
vmap <silent> <leader>y "xy:wviminfo!<CR>
nmap <silent> <leader>Y "xY:wviminfo!<CR>
nmap <silent> <leader>p :rviminfo!<CR>"xp
nmap <silent> <leader>P :rviminfo!<CR>"xP


" Editing {{{1

" Allow backspacing over auto-indent, EOL, the position where insert mode was entered
set backspace=indent,eol,start

" Allow moving cursor after EOLs
" and inside TABs
set virtualedit=all

" The key that toggles paste mode, see also vim-bracketed-paste + yo and yO in vim-unimpaired
set pastetoggle=<C-S-F12>

" Reselect the text that has just been pasted
nnoremap <Leader>v V']

" Rename an identifier in a brace-delimited block it is local to.
" Copy the inner word to the 'z' named register, call the AskForTheNewName() function that inputs the new name,
" set the mark 'x', go to the definition, go to previous unmatched '{', select all the lines down to the pairing '}',
" replace every occurence of the last search with the contents of the 'z' named register, return to the mark 'x'.
" https://gist.github.com/DelvarWorld/048616a2e3f5d1b5a9ad
nmap <silent> <Leader>R "zyiw:call AskForTheNewName()<CR>mx:silent! normal gd<CR>[{V%:s/<C-R>//<C-R>z/<CR>`x
function! AskForTheNewName()
    call inputsave()
    let @z=input("What do you want to rename '" . @z . "' to? ")
    call inputrestore()
endfunction


" Open the .vimrc file for editing
nnoremap <silent> <Leader>ev <C-w><C-v><C-l>:e $MYVIMRC<CR>
" Open the .bashrc file for editing
nnoremap <silent> <Leader>eb <C-w><C-v><C-l>:e ~/.bashrc<CR>

" Source the .vimrc/init.vim file upon writing to it
autocmd! BufWritePost .vimrc nested source %
autocmd! BufWritePost init.vim nested source %


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
" Enable Perl-compatible regexes by default ("very magic")
nnoremap / /\v
vnoremap / /\v
" Search globally by default, g switches back
set gdefault
" Clear search highlighting by <Leader><space>
nnoremap <silent> <Leader><space> :noh<CR>
" Use ripgrep for grepping
if executable('rg')
    set grepprg=rg\ --vimgrep
endif


" Make and quickfix {{{1

" Various make programs
" %:r stands for "the current file path without the extension"
command! GCC set makeprg=g++\ -O3\ -o\ %:p:r\ %
command! Make set makeprg=make\ -j${cores:-$(nproc)}

" Make with g++ or make
GCC
if filereadable("Makefile")
    Make
endif

" Don't treat 'In file included from <path>' as a file name
set errorformat^=%-GIn\ file\ included\ %.%#
" Wrap quickfix window contents
autocmd FileType qf setlocal wrap linebreak

" http://vim.wikia.com/wiki/Automatically_open_the_quickfix_window_on_:make
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Add Vim's current directory and current file's location directory to the path
set path=.,
" Add source root to the path
" set path+=$root
" Add source and include folders to the path (in the classic include/ - src/ layout)
set path+=include,../include,../../include,../../../include
set path+=src,../src,../../src,../../../src

" http://vim.wikia.com/wiki/Avoiding_the_"Hit_ENTER_to_continue"_prompts
command! -nargs=1 Silent
    \ | execute ':silent !' . <q-args>
    \ | execute ':redraw!'
command! -nargs=0 Mk
    \ | execute ':wall'
    \ | execute ':Silent make'


" For quick Git commits+pushes
function! QuickGitCommitPush()
    wall
    ! git commit -m "$(date --rfc-3339=seconds)" . && git push
endfunction
nnoremap gp :call QuickGitCommitPush()<CR>


" Completion {{{1

" Only look for completions in:
"   . - the current buffer;
"   w - buffers in other windows;
"   b - other unloaded buffers;
"   u - unloaded buffers;
"   t - tags.
" Do not look for completions in:
"   i - included files (because there can be a ton of them; use ^X^I if needed).
set complete=.,w,b,u,t
" Complete options (disable preview scratch window) {only insert the longest common prefix}
set completeopt=menuone,noinsert " {,longest}
" Limit popup menu height
set pumheight=15
" When hitting <Tab> in command line and several words match by prefix, complete the longest prefix and show a list
set wildmode=longest:full,full
set wildmenu


" Disable jj/jk (see above) in language mappings mode for the cases like "сообщать" and "положить"
function! LMap()
    if &iminsert == 1
        set iminsert=0
        inoremap jj <ESC>
        inoremap jk <ESC>
        " For the "evil" case
        " imap <ESC> <Nop>
    else
        set iminsert=1
        iunmap jj
        iunmap jk
        " For the "evil" case
        " iunmap <ESC>
    endif
    call feedkeys('a')
endfunction
inoremap <silent> <C-^> <ESC>:call LMap()<CR>


" Plugin settings and mappings {{{1

if v:version > g:_dein_minimum_vim_version
" vim-wordmotion - identifier component motions {{{2
    " Enable <Leader>-based mappings like <Leader>w to move one word inside a CamelCase or a snake_case word
    let g:wordmotion_prefix = '<Leader>'

" Mini Buffer Explorer {{{2
    " Disable auto-start
    let g:miniBufExplAutoStart = 0
    " Toggle MiniBufExplorer
    nnoremap <silent> <Leader>x :MBEToggleAll<CR>

" NERDTree (filesystem tree) {{{2
    " Toggle NERDTree
    nnoremap <silent> <Leader>T :NERDTreeToggle<CR>
    " Draw pretty arrows in the tree
    let NERDTreeDirArrows=1
    " Close Vim if NERDTree is the last window left
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
    " Open the source root in NERDTree
    nnoremap <silent> <Leader>A :NERDTree $root<CR>
    " Autoopen NERDTree if no files were specified on the command line, but switch to the new file window
    " autocmd vimenter * if !argc() | NERDTree | call feedkeys("\<C-w>l") | endif

" Gundo - undo tree (requires Vim 7.3) {{{2
    " Prefer Python 3
    let g:gundo_prefer_python3 = v:true
    " Toggle Gundo
    nnoremap <silent> <Leader>u :GundoToggle<CR>

" vim-highlightedyank - make the yanked region apparent {{{2
    if ! has('nvim')
        map y <Plug>(highlightedyank)
    endif

" Inccomplete - autocomplete #includes {{{2
    " In the inccomplete plugin, show directories too
    let g:inccomplete_showdirs = 1
    " Append slash to directories
    let g:inccomplete_appendslash = 1
    " Use the external 'find' command to navigate paths
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
    " For large directories, use .allfiles instead of spawning 'find' in Ctrl-P
    " (listfiles.sh is a custom script to do that)
    " let g:ctrlp_user_command = 'listfiles.sh %s'
    " Use Ctrl-P in a mixed files/buffers/MRU mode
    let g:ctrlp_cmd = 'CtrlPMixed'
    " Use only the directory of the current file in file mode
    let g:ctrlp_working_path_mode = 'c'

" Syntastic - syntax checker {{{2
    " Use a custom script for syntastic ('check' is my custom script that runs compilation with necessary options)
    let g:syntastic_cpp_compiler = 'check'
    " Do not search for the headers of special libraries
    let g:syntastic_cpp_no_include_search = 1
    " Do not use the default includes
    let g:syntastic_cpp_no_default_include_dirs = 1
    " Do not check on exit-triggered writes
    let g:syntastic_check_on_wq = 0
    " ...and on all writes (use :SyntasticCheck and :SyntasticToggleMode)
    let g:syntastic_mode_map = { "mode": "passive" }
    " Save and check syntax - superceded by YouCompleteMe when available
    if g:_ycm_enabled != 1
        nnoremap <silent> <Leader>s :w<CR>:SyntasticCheck<CR>
    endif

" QuickRun - execute whole/part of the edited file {{{2
    " Run the current file (for scripts)
    let g:quickrun_no_default_key_mappings = 1
    nnoremap <silent> <Leader><Leader><Leader> :QuickRun<CR>

" YouCompleteMe - autocompletion {{{2
    if g:_ycm_enabled == 1
        " Whitelisted flag files
        python import os.path
        let g:ycm_extra_conf_globlist = [
            \ pyeval('os.path.realpath(os.path.expanduser("~/.ycm_extra_conf.py"))'),
            \ pyeval('os.path.realpath(os.path.expandvars("$root/.ycm_extra_conf.py"))')
        \ ]
        nnoremap <silent> <Leader>s :w<CR>:YcmForceCompileAndDiagnostics<CR>
        " Add the preview string to completeopt so that the completion preview window becomes available
        " let g:ycm_add_preview_to_completeopt = 1
        " Do not trigger as-you-go completion
        " let g:ycm_min_num_of_chars_for_completion = 100500
        " Go to the definition/declaration
        nnoremap <silent> <Leader>gd :YcmCompleter GoTo<CR>
    endif

" EasyAlign - text alignment {{{2
    " Activate interactive mode
    vmap <Enter> <Plug>(EasyAlign)

" Comfortable motion - smooth scrolling {{{2
    " Mouse wheel support
    noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
    noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
    " Scroll by visual, not logical lines
    let g:comfortable_motion_scroll_down_key = "gj"
    let g:comfortable_motion_scroll_up_key = "gk"

" indentLine - indentation markers {{{2
    " Disable concealing under cursor for insert mode
    let g:indentLine_concealcursor = 'nc'
    " Completely disable it for TeX
    let g:indentLine_fileTypeExclude = ['tex']
    autocmd syntax tex setlocal conceallevel=0

" SplitJoin - split/join argument lists into multiple/one line {{{2
    " Put brackets on lines of their own
    let g:splitjoin_python_brackets_on_separate_lines = 1

" ConqueTerm - a terminal inside Vim (replaced by native termnal in NeoVim/Vim 8+) {{{2
    if has('terminal') || has('nvim')
        " Keyboard mappings for terminal mode common for Vim 8+ and NeoVim
        " Esc to exit to normal mode (disabled for set -o vi to take over)
        " tnoremap <Esc> <C-\><C-n>
        " jk to exit to normal mode
        tnoremap jk <C-\><C-n>
        " jj to exit to normal mode
        tnoremap jj <C-\><C-n>

        " Easy window navigation
        tnoremap <C-h> <C-\><C-n><C-w>h
        tnoremap <C-j> <C-\><C-n><C-w>j
        tnoremap <C-k> <C-\><C-n><C-w>k
        tnoremap <C-l> <C-\><C-n><C-w>l
    endif
    if has('terminal')
        " Open terminal
        noremap <silent> <Leader>t :vert terminal bash<CR>
        " Open Python
        noremap <silent> <Leader>py :vert terminal python<CR>
    elseif has('nvim')
        " Open terminal
        nnoremap <silent> <Leader>t :vsplit term://bash<CR>
        " Open Python
        nnoremap <silent> <Leader>py :vsplit term://python<CR>

        " Automatically enter and leave insert mode
        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    else
        " Open terminal
        nnoremap <silent> <Leader>t :ConqueTermSplit bash<CR>
        " Open Python
        nnoremap <silent> <Leader>py :ConqueTermSplit python<CR>
    endif

" Rainbow Parentheses Improved - highlight pairs of matching parentheses in distinct colors
let g:rainbow_active = 0  " Disable by default but allow :RainbowToggle

" Vim-gf-python - python-aware gf (go to file) {{{2
    " Extend sys.path for the python gf plugin
    function! PythonPath(...)
        for path in a:000
            python import os, vim, sys; sys.path.append(vim.eval('expand(path)'))
        endfor
    endfunction
    command! -nargs=+ PythonPath call PythonPath(<args>)

" Python-Mode - Python IDE features (with Jedi-vim completion alternative) {{{2
    " Maximum line width
    let g:pymode_options_max_line_length = &colorcolumn - 1
    " Disable indentation override
    let g:pymode_indent = v:false
    " Disable Rope autocompletion in favour of jedi-vim
    if g:_jedi_enabled
        let g:pymode_rope = v:false

        " Jedi-vim - Python autocompletion
        let g:jedi#auto_vim_configuration = v:false
        " Disable choosing the first function/method on autocomplete
        let g:jedi#popup_select_first = v:false
        " Show function signatures in the Vim's command line, because pop-ups
        " seem to leave garbage in my configuration sometimes
        let g:jedi#show_call_signatures = "2"
        " Add a '<Leader>gd' (go to the definition) for consistency with the other mappings
        let g:jedi#goto_definitions_command = "<Leader>gd"
    else
        let g:pymode_rope = v:true

        " Python autocompletion via Rope
        " Disable project lookup
        let g:pymode_rope_lookup_project = v:false
        " Disable .ropeproject creation
        let g:pymode_rope_project_root = '/tmp'
        " Show the docstring
        let g:pymode_rope_show_doc_bind = '<Leader>d'
        " Go to the definition
        let g:pymode_rope_goto_definition_bind = '<Leader>gd'
        " The command to execute when a definition has been found
        let g:pymode_rope_goto_definition_cmd = 'e'
        " Offer to import unresolved objects after completion
        let g:pymode_rope_autoimport_import_after_complete = v:true
        " Disable complete-on-dot in insert mode, use manual <C-X><C-O> or <C-Space>
        let g:pymode_rope_complete_on_dot = v:false
    endif
    " Disable folding (https://github.com/python-mode/python-mode/issues/523)
    let g:pymode_folding = v:false
    " Use PymodeLint instead of SyntasticCheck for Python
    autocmd FileType python nnoremap <buffer> <silent> <Leader>s :w<CR>:PymodeLint<CR>

" UltiSnips - Code snippets {{{2
    " Mappings not conflicting with YouCompleteMe
    let g:UltiSnipsExpandTrigger="<NL>"
    let g:UltiSnipsJumpForwardTrigger="<C-n>"
    let g:UltiSnipsJumpBackwardTrigger="<C-p>"

" vim-signify - Highlighting changed lines in the gutter for VCS-tracked files {{{2
    " Disable by default
    let g:signify_disable_by_default = 1
    " Toggle with <Leader>S
    nmap <Leader>S :SignifyToggle<CR>
    " Show hunk diff with <Leader>D
    nmap <Leader>D :SignifyHunkDiff<CR>
    " Undo hunk with <Leader>U
    nmap <Leader>U :SignifyHunkUndo<CR>

" Ack.vim - An Ack (and replacements) interface for Vim
    if executable('rg')
        let g:ackprg = 'rg --vimgrep --no-heading'
    endif

" Vim-TaskWarrior - TaskWarrior command-line task manager Vim interface {{{2
    " Open the TaskWarrior's 'task next' report
    nmap T :TW<CR>
    " Clear filters (Ctrl-U clears the line in Insert mode)
    autocmd FileType taskreport nmap <buffer> F <Plug>(taskwarrior_filter)<C-U><CR>
    " Merge with the remote location
    autocmd FileType taskreport nmap <buffer> <Leader>m :TW merge<CR>
    " Modify the task priority
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
    " Clear the defaults (with Ctrl-U) when asking for a report name
    autocmd FileType taskreport nmap <buffer> r <Plug>(taskwarrior_report)<C-U>
    " Default fields to ask when adding a new task
    let g:task_default_prompt = ['project', 'description', 'priority']
    " .taskrc overrides
    let g:task_rc_override = 'rc.defaultwidth=0 rc.defaultheight=0'

" fakeclip - access various alternate clipboards even if `+clipboard` is missing
    " Force using the plugin when not under X, even when `+clipboard` is set.
    if empty($DISPLAY)
        let g:fakeclip_provide_clipboard_key_mappings = 1
    endif

" Sideways - move and jump to the elements of comma-separated lists (e.g. arguments) {{{2
    nnoremap <silent> <Leader>h :SidewaysLeft<CR>
    nnoremap <silent> <Leader>l :SidewaysRight<CR>

" EnhancedDiff - use git-diff to obtain better diffs {{{2
    " If Vim is started in diff mode, use EnhancedDiff
    if &diff
        let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
    endif

" LocalRC - Allow for per-project settings in the .local.vimrc file of the project root {{{2
    " Simplify the per-filetype regex to avoid globbing is highly populated directories upways along the path
    let g:localrc_filetype = '.local.%s.vimrc'
endif


" Local machine-specific .vimrc {{{1
" Execute ~/.specifics.vim
if filereadable(expand('~/.specifics.vim'))
    execute 'source ~/.specifics.vim'
endif

" Vim folding for this file {{{1
" vim: set foldmethod=marker:
