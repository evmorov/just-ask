subscribeToAnswers = ->
  return if App.answers
  App.answers = App.cable.subscriptions.create 'AnswersChannel',
    received: (data) ->
      return if gon.user_id is data.answer.user_id
      $('#answers').append(JST['answer'](data))

addOnEditAnswerListener = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(@).hide()
    answer_id = $(@).data('answerId')
    $("form#edit-answer-#{answer_id}").show()

ready = ->
  subscribeToAnswers()
  addOnEditAnswerListener()

$(document).on('turbolinks:load', ready)

@removeTheBestAnswer = ->
  $('.best-answer-selected').removeClass 'best-answer-selected'
  $('.best-answer-link-selected').removeClass 'best-answer-link-selected'

@isSelectedAnswerAlreadyTheBest = (answerId) ->
  $('.best-answer-selected').attr('id') is "answer_#{answerId}"

@toggleTheBestAnswer = (answerId) ->
  $("#best-answer-link-#{answerId}").toggleClass 'best-answer-link-selected'
  $("#answer_#{answerId}").fadeOut(300).delay(300).queue ->
    $(@).toggleClass 'best-answer-selected'
    $(@).fadeIn(500).dequeue()
