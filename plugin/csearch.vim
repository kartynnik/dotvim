" Maintainer:  Yury Kartynnik
" Last Change: 20130324

let $csearch = "f"

"------------------------------------------------------------------------
func! CodeSearch(args)
"------------------------------------------------------------------------

  let cmd = "COLORS=no $csearch " . a:args

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
      echohl ErrorMsg | echo "Couldn't find code matching '" . a:args . "'" | echohl None
  endif
endfunc

" Usage: :CodeSearch regexp fileRegexp matches
command -nargs=+ CodeSearch call CodeSearch("<args>")

" Perform code search for the regex under cursor
nmap K :call CodeSearch(expand("<cword>"))<CR>
nmap <leader>f :CodeSearch 
