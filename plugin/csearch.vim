" Maintainer:  Yury Kartynnik
" Last Change: 20120416

let $csearch = "csearch"

"------------------------------------------------------------------------
func! FindRegex(regex)
"------------------------------------------------------------------------

  let cmd = "$csearch '" . a:regex . "'"

  " echo "Performing command: " . cmd
  cex system(cmd)
  copen
  let b:csearch_regex = a:regex
  setlocal statusline=%{b:csearch_regex}
  if len(getqflist()) == 1
      cfirst
      cclose
  elseif len(getqflist()) == 0
      cclose
      echohl ErrorMsg | echo "Couldn't find '" . a:regex . "'" | echohl None
  endif
endfunc

command -nargs=1 FindRegex call FindRegex("<args>")

" Perform usage search for the regex under cursor
map <leader>U :call FindRegex(expand("<cword>"))<CR>
map <leader>R :FindRegex 
                                 
