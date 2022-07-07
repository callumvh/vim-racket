let g:racket_hash_lang_modifiers =
      \ extend(get(g:, 'racket_hash_lang_modifiers', []), [
      \ 'htdp/bsl',
      \ 'htdp/bsl+',
      \ 'htdp/isl',
      \ 'htdp/isl+',
      \ 'htdp/asl',
      \ 'at-exp',
      \ 's-exp',
      \ 'errortrace',
      \ 'pollen/mode',
      \ ])

let g:racket_hash_lang_modifiers_regex =
      \ get(g:, 'racket_hash_lang_modifiers_regex',
      \ '\%('.
      \     join(map(deepcopy(g:racket_hash_lang_modifiers),
      \              {_, v -> printf('\<%s\>', escape(v, '\'))}),
      \     '\|')
      \ .'\)')

let g:racket_hash_lang_regexp = get(g:, 'racket_hash_lang_regexp',
      \ '^#lang\s\+\%\('.g:racket_hash_lang_modifiers_regex.'\s\+\)\?\([^][)(}{[:space:]]\+\)')
let g:racket_hash_lang_dict =
      \ extend(get(g:, 'racket_hash_lang_dict', #{}), {
      \   'htdp/bsl':'racket',          
      \   'htdp/bsl+':'racket',       
      \   'htdp/isl':'racket',       
      \   'htdp/isl+':'racket',       
      \   'htdp/asl':'racket',       
      \   'racket/base': 'racket',
      \   'racket/gui': 'racket',
      \   'typed/racket': 'racket',
      \   'typed/racket/base': 'racket',
      \   'br': 'racket',
      \   'br/quicklang': 'racket',
      \   'scribble/base': 'scribble',
      \   'scribble/manual': 'scribble',
      \   'info': 'racket-info',
      \   'setup/infotab': 'racket-info',
      \   'syntax/module-reader': 'racket',
      \ }, 'keep') " keep prefers user dict to the default

" Tries to detect filetype from #lang line; defaults to ft=racket.
function! RacketDetectHashLang()
  let matches = matchlist(getline(1), g:racket_hash_lang_regexp)
  if ! empty(matches)
    execute 'set filetype='.get(g:racket_hash_lang_dict, matches[1], substitute(matches[1], '[/\*?[|<>]', '', 'g'))
  else
    set filetype=racket
  endif
endfunction

au BufRead,BufNewFile *.rkt,*.rktl call RacketDetectHashLang()
