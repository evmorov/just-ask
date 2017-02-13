addOnChangeSearchTypeListener = ->
  $('#search-type').on 'change', (e) ->
    e.preventDefault()
    $('#search-form').attr('action', "/search/#{@.value}")

$(document).on('turbolinks:load', addOnChangeSearchTypeListener)
