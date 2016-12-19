subscribeToQuestions = ->
  return if App.questions
  App.questions = App.cable.subscriptions.create 'QuestionsChannel',
    received: (question) ->
      return if gon.user_id is question.user_id
      $('#questions').append(JST['templates/question'](question))

ready = ->
  subscribeToQuestions()

$(document).on('turbolinks:load', ready)
