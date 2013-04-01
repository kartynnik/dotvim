" Maintainer:  Yury Kartynnik
" Last Change: 20130324

if ! exists("g:csearch_command")
    let g:csearch_command = "f"
endif

if ! exists("g:csearch_tabs")
    let g:csearch_tabs = 0
endif

"------------------------------------------------------------------------
func! CodeSearch(args)
"------------------------------------------------------------------------
  if g:csearch_tabs
      tabnew
  endif

  let cmd = "CS_WSVN=no CS_COLORS=no " . g:csearch_command . " " . a:args

  echom "Performing command: " . cmd
  cex system(cmd)
  copen
  let b:csearch_args = a:args
  setlocal statusline=%{b:csearch_args}
  if len(getqflist()) == 2
      cfirst
      cclose
  elseif len(getqflist()) <= 1
      cclose
      if g:csearch_tabs
          tabclose
      endif
      echohl ErrorMsg | echo "Couldn't find code matching '" . a:args . "'" | echohl None
  endif
endfunc

" Usage: :CodeSearchEx regexp -f fileRegexp -m matches ... (see f usage)
command -nargs=+ CodeSearchEx call CodeSearch("<args>")
command -nargs=+ CodeSearch   call CodeSearch("'<args>'")

" Perform code search for the regexp under cursor
nmap K :call CodeSearch("'\\b" . expand("<cword>") . "\\b'")<CR>
nmap <leader>f :CodeSearch 
nmap <leader>F :CodeSearchEx 
