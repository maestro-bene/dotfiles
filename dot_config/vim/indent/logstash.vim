function! GetLogstashIndent()
  " Obtenir la ligne précédente non vide
  let prev_line_num = prevnonblank(v:lnum - 1)
  if prev_line_num == 0
    return 0
  endif

  let prev_line = getline(prev_line_num)
  let current_line = getline(v:lnum)

  " Si la ligne courante est un commentaire
  if current_line =~ '^\s*#'
    " Vérifier la fin de la ligne précédente
    if prev_line =~ '[{[(]\s*$'
      " Si la ligne précédente se termine par {, [, ou (
      " alors indenter d'un niveau supplémentaire
      return indent(prev_line_num) + &shiftwidth
    else
      " Sinon, aligner avec la ligne précédente
      return indent(prev_line_num)
    endif
  endif

  " Par défaut, ne pas changer l'indentation
  return -1
endfunction

" Fonction pour obtenir la ligne précédente non vide
function! prevnonblank(lnum)
  while a:lnum >= 1
    if getline(a:lnum) =~ '\S'
      return a:lnum
    endif
    let a:lnum -= 1
  endwhile
  return 0
endfunction

