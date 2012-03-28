" Maintainer:  Yury Kartynnik
" Last Change: 20120324

let $csearch = "csearch"

"------------------------------------------------------------------------
func! FindRegex( regex )
"------------------------------------------------------------------------

  let cmd = "$csearch " . a:regex

  " echo "Performing command: " . cmd
  cex system( cmd )
  copen
  silent exe "file " . a:regex
endfunc

command -nargs=1 FindRegex call FindRegex("<args>")

" Perform usage search for the regex under cursor
map <leader>U :call FindRegex( expand("<cword>") )<CR>
map <leader>R :FindRegex 
                                 
