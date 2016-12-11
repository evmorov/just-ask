ready = ->
  $('.vote').bind 'ajax:success', (e, data, status, xhr) ->
    vote = $.parseJSON(xhr.responseText)

    voteLocator = "#vote-#{vote.votable}-#{vote.votable_id}"
    $(voteLocator).removeClass().addClass("vote #{vote.vote_state}")
    $("#{voteLocator} > .score").text(vote.total_score)

$(document).on('turbolinks:load', ready)
