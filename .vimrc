" First run {{{1
  " Autoinstall `vim-plug`.
  if !filereadable(expand('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif


" Leader {{{1
  " Set `<Leader>` upfront so that `<Leader>`-based mappings below take it into account.
  let mapleader = ' '


" Plugins {{{1
  call plug#begin('~/.vim/plugins')

  " Color schemes {{{2
    " My modified version of the Janah color scheme.
    Plug 'kartynnik/vim-janah'

  " Library plugins serving as dependencies for others {{{2
    " Allows to repeat the plugin mappings with `.` in the normal mode.
    Plug 'tpope/vim-repeat'

    " Allows to define new text objects (see the next section).
    " https://github.com/kana/vim-textobj-user/wiki lists many useful plugins doing that.
    Plug 'kana/vim-textobj-user'

    " A plugin that is actually standalone (provides alignment via `:Tab[ularize]`,
    " but added as a dependency of `vim-markdown`.
    Plug 'godlygeek/tabular'

  " New text objects {{{2
    " `CamelCase` / `snake_case` etc. identifier parts.
    Plug 'chaoren/vim-wordmotion'
      " Prepend a motion by `<Leader>` to move granularly.
      let g:wordmotion_prefix = '<Leader>'

    " "In"/"an"/"inside"/"around" for different brackets, separators, and arguments.
    " E.g. `aa` - an argument in a list of arguments, `i/` - a path component (`a/` - plus slash).
    " Makes e.g. the usual "inside quotes" smarter by counting and "inside brackets" multiline.
    Plug 'wellle/targets.vim'

    " Python: "A class"/"inner class" (`ac`/`ic`), "a function"/"inner function" (`af`/`if`)
    " text objects + class/function motions (`[p`/`]p` + `c`/`f`).
    Plug 'bps/vim-textobj-python'

    " `ii`/`ai`/`aI` - current indentation level / + a line above / + above and below.
    Plug 'michaeljsmith/vim-indent-object'

  " Editing and navigation {{{2
    " Autodetect indentation options based on current or other similar files.
    Plug 'tpope/vim-sleuth'

    " `vv`/`viv`/`vav` for smart detection of relevant inner/outer pairs.
    Plug 'gorkunov/smartpairs.vim'

    " `f`/`F`/`t`/`T` support searching for a character across lines.
    Plug 'dahu/vim-fanfingtastic'
      nmap - <Plug>fanfingtastic_,
      xmap - <Plug>fanfingtastic_,
      omap - <Plug>fanfingtastic_,

    " Move and jump to elements of comma-separated lists (e.g. function arguments).
    Plug 'AndrewRadev/sideways.vim'
      nnoremap <silent> <Leader>h :SidewaysLeft<CR>
      nnoremap <silent> <Leader>l :SidewaysRight<CR>

    " `<Leader><Leader>` + motion creates Vimium-like motion hints around the document.
    Plug 'easymotion/vim-easymotion'

    " Makes H a text object for the LHS of an expression (=, ==, =>) and L for the RHS.
    " E.g.: `ciL` in "stri|ng a = 'some string';" changes the left hand side.
    Plug 'vim-scripts/text-object-left-and-right'

    " Text objects for surrounding brackets, tags... (`:help surround.txt`).
    " E.g.: `ds(` removes the surrounding parentheses,
    " while `cs(]` replaces them by square brackets.
    Plug 'tpope/vim-surround'

    " For modern terminals, frees from the need to `:set paste` / `:set nopaste` etc.
    Plug 'wincent/terminus'

    " Commenting with `gc*`.
    Plug 'tpope/vim-commentary'

    " Switching between a single-line statement and a multi-line one (`gJ` / `gS`).
    Plug 'AndrewRadev/splitjoin.vim'
      " Python: Put brackets on lines of their own.
      let g:splitjoin_python_brackets_on_separate_lines = 1

    " Search for the current visual selection with `*`.
    Plug 'haya14busa/vim-asterisk'
      map * <Plug>(asterisk-*)
      map # <Plug>(asterisk-#)
      map g* <Plug>(asterisk-g*)
      map g# <Plug>(asterisk-g#)
      " The `z`-mappings don't move the cursor (useful for highlighting matches first).
      map z* <Plug>(asterisk-z*)
      map z# <Plug>(asterisk-z#)
      map gz* <Plug>(asterisk-gz*)
      map gz# <Plug>(asterisk-gz#)
      " Keep the relative position within the word while iterating over matches.
      let g:asterisk#keeppos = 1

    " `:BufferRing{Reverse,Forward}` to move to the previous  / next used buffer
    " in the "buffer ring" (circular deduplicated version of the jumplist).
    Plug 'landonb/vim-buffer-ring', { 'branch': 'develop' }
      nnoremap <silent> <Leader><C-o> :BufferRingReverse<CR>
      nnoremap <silent> <Leader><C-i> :BufferRingForward<CR>

  " Interface {{{2
    " Many paired commands to toggle settings (like `[on`, `]on`, `con` /
    " `[ow`, `]ow`, `cow` to enable/disable/toggle line numbering/wrapping, `:help unimpaired`).
    Plug 'tpope/vim-unimpaired'

    " Smooth scrolling.
    Plug 'yuttie/comfortable-motion.vim'
      " Mouse wheel support.
      noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
      noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
      " Scroll by visual, not logical lines.
      let g:comfortable_motion_scroll_down_key = 'gj'
      let g:comfortable_motion_scroll_up_key = 'gk'

    " Highlight other occurences of the word under cursor.
    Plug 'RRethy/vim-illuminate'

    " Highlight matching parentheses in different colors.
    Plug 'luochen1990/rainbow'
      let g:rainbow_active = 0

    " Live preview for results of Ex commands.
    if has('nvim')
      set inccommand
    else
      Plug 'markonm/traces.vim'
    endif

    Plug 'vim-airline/vim-airline'

    " Indentation markers.
    Plug 'Yggdroot/indentLine'
      " Set the concealed character color.
      let g:indentLine_color_term = 235
      " Use a Unicode character that comprises the whole character cell height.
      let g:indentLine_char = '▏'
      " Disable concealing in the current line for insert mode.
      let g:indentLine_concealcursor = ''
      " Completely disable for these file types.
      let g:indentLine_fileTypeExclude = ['markdown', 'tex']
      augroup re_enable_concealing
        " `indentLine_fileTypeExclude` above leads to resetting `conceallevel`.
        autocmd!
        autocmd syntax markdown setlocal conceallevel=2
      augroup END

    " Undo tree.
    Plug 'sjl/gundo.vim'
      " Prefer Python 3.
      let g:gundo_prefer_python3 = v:true
      " Toggle Gundo.
      nnoremap <silent> <Leader>u :GundoToggle<CR>

    " `<C-w>u` to undo closing a window.
    Plug 'AndrewRadev/undoquit.vim'

    " `fzf`-based fuzzy search.
    Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'
      let g:fzf_layout = { 'down': '~20%' }
      nmap <silent> <C-p> :Files<CR>
      nmap <silent> <C-p><C-p> :Files<CR>
      nmap <silent> <C-p>h :History<CR>
      nmap <silent> <C-p>; :History:<CR>
      nmap <silent> <C-p>: :History:<CR>
      nmap <silent> <C-p>/ :History/<CR>

    " Adds a "Diff" option when Vim finds an existing swap file.
    Plug 'chrisbra/Recover.vim'

    " `:DirDiff A B` to run `vimdiff` on the contents of two file trees.
    Plug 'will133/vim-dirdiff'

    " Conflict resolution based on a 2-way diff of the parts between conflict markers.
    " See https://github.com/haraldkl/diffconflicts#installation for Git/Mercurial installation.
    Plug 'haraldkl/diffconflicts'

    " UNIX shell command wrappers
    " (`:Rename`, `:SudoWrite`, `:Chmod`, `:Locate`... - see `:help eunuch-commands`).
    " Automatically makes new files with a shebang executable.
    Plug 'tpope/vim-eunuch'

    " Executes the whole / a part of the edited file.
    Plug 'thinca/vim-quickrun'
      let g:quickrun_no_default_key_mappings = 1
      " Run the current file (for scripts).
      nnoremap <silent> <Leader><Leader><Leader> :QuickRun<CR>

    " A secure alternative to modelines.
    Plug 'ypcrts/securemodelines'
      let g:secure_modelines_allowed_items = [
          \ "textwidth",     "tw",
          \ "softtabstop",   "sts",
          \ "tabstop",       "ts",
          \ "shiftwidth",    "sw",
          \ "expandtab",     "et",   "noexpandtab",   "noet",
          \ "filetype",      "ft",
          \ "foldlevel",     "fdl",
          \ "commentstring", "cms",
          \ "foldmethod",    "fdm",
          \ "readonly",      "ro",   "noreadonly",    "noro",
          \ "rightleft",     "rl",   "norightleft",   "norl",
          \ "cindent",       "cin",  "nocindent",     "nocin",
          \ "smartindent",   "si",   "nosmartindent", "nosi",
          \ "autoindent",    "ai",   "noautoindent",  "noai",
          \ "wrap",                  "nowrap",
          \ "statusline",
          \ "laststatus",
          \ "number",                "nonumber",
          \ ]

    " `gx` partially provides its functionality,
    " but is broken at the time of this writing (https://github.com/vim/vim/issues/4738).
    " `g<CR>` - search the word under cursor with DuckDuckGo;
    " `gG` - with Google; gW - with Wikipedia.
    Plug 'dhruvasagar/vim-open-url'
      nmap gx <Plug>(open-url-browser)
      xmap gx <Plug>(open-url-browser)

    " `<Leader><Leader>+' increases the GUI font size, allowing to repeat `+` multiple times.
    Plug 'drmikehenry/vim-fontsize'

  " File type-specific {{{2
  Plug 'plasticboy/vim-markdown'
    let g:vim_markdown_new_list_item_indent = 2
    augroup disable_vim_markdown_extended_gx
      autocmd!
      autocmd syntax markdown silent! unmap <buffer> gx
    augroup END

  " Machine-specific {{{2
    if filereadable(expand('~/.local.vimrc.plugins'))
      source ~/.local.vimrc.plugins
    endif

  call plug#end()


" Interface {{{1
  " Enable syntax highlighting, filling in the colors for groups with missing definintions.
  syntax enable

  " Use TrueColor if possible.
  if has('termguicolors') && $TERM == 'xterm-256color'
    set termguicolors
  endif

  " Color scheme.
  " Suppress errors if the color scheme has not yet been installed.
  silent! colorscheme janah

  " Indicate a fast terminal connection:
  " smoother redrawing, better for copying in graphic terminals.
  set ttyfast

  " Don't wrap long lines by default (use the `cow` mapping from `vim-unimpaired` to toggle).
  set nowrap
  " ...except in diff mode.
  augroup wrap_in_diff
    autocmd!
    autocmd FilterWritePre * if &diff | setlocal wrap | endif
  augroup END

  " When wrapping, use `breakat` (whitespace / punctuation by default).
  set linebreak
  " Display as much as possible of the last line instead of `@`s.
  set display=lastline

  " Minimal number of screen lines to keep above and below the cursor.
  set scrolloff=3

  " Show cursor position and percentage.
  set ruler

  " Show line numbers.
  set number
  " ...except in the terminal
  augroup no_line_numbering_in_terminal
    autocmd!
    if has('nvim')
      autocmd TermOpen * setlocal nonumber
    else
      autocmd TerminalOpen * setlocal nonumber
    endif
  augroup END

  " Highlight matching brackets
  set showmatch
  " Include angle brackets in bracket matching
  setglobal matchpairs+=<:>

  " Always show the status line.
  set laststatus=2

  " Show the currently typed command in lower right corner.
  set showcmd

  " When jumping to a buffer, use a window already containing it.
  set switchbuf=useopen

  " GUI elements.
  " `a` - autoselect (become the owner of X selection in visual mode).
  " `b` - bottom horizontal scrollbar.
  " `c` - console dialogs instead of popups for simple choices.
  " `d` - dark theme variant if available.
  " `l` - left-hand scrollbar (always).
  " `L` - left-hand scrollbar (when there's a vertical split).
  " `m` - menu bar.
  " `r` - right-hand scrollbar (always).
  " `R` - right-hand scrollbar (when there's a vertical split).
  " `T` - toolbar.
  if has('gui')
    set guioptions+=c
    set guioptions+=d
    set guioptions-=h
    set guioptions-=l
    set guioptions-=L
    set guioptions-=m
    set guioptions-=r
    set guioptions-=R
    set guioptions-=T
  endif


" Basic mappings {{{1
  " Use `jj` as an alternative to `<Esc>`.
  inoremap jj <Esc>
  " `jk` is another alternative.
  inoremap jk <Esc>

  " Use gj/gk by default (move by visible lines, not logical ones).
  nnoremap j gj
  nnoremap k gk
  vnoremap j gj
  vnoremap k gk

  " Visually select pasted text (actually "previously changed or yanked").
  nmap gp `[v`]

  " Easy window navigation.
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l

  " Run `&makeprg`, and jump to the first QuickFix error (see `:help errorformat`).
  nmap <silent> <Leader>m :make<CR>


" Filesystem {{{1
  " Auto-change the current directory to that of the currently edited file.
  try
      set autochdir
  catch
  endtry

  " When a file is changed outside with no local modifications, reload it.
  set autoread

  " Auto-write on some commands, e.g. `make`.
  set autowrite

  " Directories for swap files.
  set dir=/var/tmp,/tmp

  " Automatically ask for confirmation on unsaved changes, read-only writes etc.
  set confirm

  " Use the terminal code to display a visual bell (most likely a screen flash) instead of a beep.
  set visualbell
  " And then use an empty code to produce the visual bell, i.e. do nothing.
  set t_vb=

  " Allow to have hidden modified buffers not currently opened in any windows.
  set hidden

  " Show the current file path
  nnoremap <silent> <Leader>: :echo expand("%:p")<CR>

  " Add Vim's current directory and current file's location directory to the path.
  set path=.,

  " Source the .vimrc/init.vim file upon writing to it
  augroup source_written_vimrc
    autocmd!
    autocmd BufWritePost *.vimrc* nested source %
    autocmd BufWritePost init.vim nested source %
  augroup END


" Encoding, tabulation and spaces, indentation {{{1
  " Use UTF-8 encoding internally.
  set encoding=utf-8

  " Try these encodings in order when opening a file.
  set fileencodings=ucs-bom,utf-8,windows-1251

  " Do not automatically wrap lines in text files and comments.
  set textwidth=0

  " Enable file type-based syntax plugin and indentation plugin loading.
  filetype plugin indent on

  " Spaces in a `<TAB>`.
  set tabstop=4
  " Use spaces instead of `<TAB>`s by default (unless `vim-sleuth` detects preexisting ones).
  set expandtab

  " Enable automatic indentation.
  set autoindent
  " Number of spaces for an autoindentation step (zero corresponds to the value of `tabstop`).
  set shiftwidth=0
  " Language-specific autoindenting.
  set smartindent
  " Let `<Backspace>` undo indentation.
  set smarttab

  " Show tabs as `>-------`, trailing spaces as `_`,
  " and non-breakable spaces as `!` (see `:help listchars`).
  set list
  set listchars=tab:>-,trail:_,nbsp:!

  " Don't conceal the current line in normal mode (like in insert mode by default).
  set concealcursor=

  " Auto-remove spaces at ends of lines in source files.
  function! TrimWhitespace()
    " Credits: https://vi.stackexchange.com/a/456.
    let l:view_state = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:view_state)
  endfunction
  augroup trim_whitespace
    autocmd!
    autocmd BufWritePre *.{c,cc,cxx,cpp,h,py,sh,vimrc} call TrimWhitespace()
  augroup END


" Editing {{{1
  " Allow backspacing over auto-indent, EOL, the position where insert mode was entered
  set backspace=indent,eol,start

  " Allow moving cursor after EOLs and inside `<Tab>` characters.
  set virtualedit=all

  " Delete comment character when joining commented lines
  set formatoptions+=j


" Search {{{1
  " Ignore case in search strings...
  set ignorecase
  " ...unless they have uppercase characters.
  set smartcase

  " Highlight search results.
  set hlsearch
  " Clear search highlight by `<Leader>/`.
  nnoremap <silent> <Leader>/ :noh<CR>

  " Incremental search (as you type).
  set incsearch

  " Wrap around the beginning of the file when searching.
  set wrapscan

  " Enable Perl-compatible regexes by default ("very magic").
  nnoremap / /\v
  vnoremap / /\v

  " Substitute globally by default, `/g` switches back.
  set gdefault

  " Use `rg` (ripgrep) as a substitution for `grep`.
  if executable('rg')
      set grepprg=rg\ --vimgrep
  endif


" Syntax highlighting {{{1
  " Limit syntax highlighting to 1000 first symbols in a line (e.g. for JSON without newlines).
  set synmaxcol=1000


" Completion {{{1
  " Disable searching for completions in the included files (often too slow).
  " Use `<Ctrl-X><Ctrl-I>` to manually trigger it instead.
  set complete-=i

  " Complete options: Show even if only one option is available;
  " add extra preview information; don't modify the text.
  set completeopt=menuone,preview,noinsert

  " Limit the popup menu height.
  set pumheight=15

  " When several words match by prefix upon hitting `<Tab>` in the command line,
  " complete the longest common prefix and show a list (`longest:full` with `wildmenu`).
  " If `<Tab>` is pressed again, the match is completed with the next choice (`full`).
  set wildmenu
  set wildmode=longest:full,full


" Machine-specific customizations {{{1
  if filereadable(expand('~/.local.vimrc.after'))
    source ~/.local.vimrc.after
  endif


" A modeline for this file {{{1
" vim: foldmethod=marker textwidth=100 colorcolumn=100
