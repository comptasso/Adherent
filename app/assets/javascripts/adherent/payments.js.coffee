# Lance l'impression de la page avec l'icône de classe icon_print
$ ->
  $('img.icon_print').click (e) ->
    e.preventDefault()
    javascript:print()