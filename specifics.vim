if filereadable("CMakeLists.txt")
    " set makeprg=oc\ %
    set makeprg=om\ release\ -j24
endif

" Add source root to the path
set path+=$root

" Add source root as tags location
" set tags+=$root

" clang_complete
let g:clang_complete_enabled = 1
" Use libclang.so instead of clang executable
" let g:clang_exec='~/llvm/usr/local/bin/clang'
let g:clang_use_library = 1
let g:clang_library_path = '/home/kartynnik/bin/llvm/usr/local/lib'
" Periodically update the quickfix window
" let g:clang_periodic_quickfix = 1
" Disable auto popup, use <Tab> to autocomplete
let g:clang_complete_auto = 0
" Show clang errors in the quickfix window
let g:clang_complete_copen = 1
" Auto select the first entry and insert it
let g:clang_auto_select = 2
" Complete preprocessor macros and constants
let g:clang_complete_macros = 1
" Complete code patterns. e.g. loops
let g:clang_complete_patterns = 1

" Clang quickfix window
nnoremap <silent> <leader>f :call g:ClangUpdateQuickFix()<CR>

" Activate clang_complete via SuperTab
let g:SuperTabContextDefaultCompletionType = "<c-x><c-u>"

" Show relative numbers
" set relativenumber

" Open source root in NERDTree
nnoremap <leader>A :NERDTree $root<CR>

" For large directories, use .allfiles instead of find in Ctrl-P
let g:ctrlp_user_command = 'listfiles.sh %s'

" Show fancy unicode symbols in powerline
let g:Powerline_symbols = 'fancy'
