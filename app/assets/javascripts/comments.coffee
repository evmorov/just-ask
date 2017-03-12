subscribeToComments = ->
  return if App.comments
  App.comments = App.cable.subscriptions.create 'CommentsChannel',
    received: (data) ->
      return if gon.user_id is data.comment.user_id
      commentableClass = data.comment.commentable_type.toLowerCase()
      addCommentEl = $("#add-comment-to-#{commentableClass}-#{data.comment.commentable_id}")
      addCommentEl.children('.comments').append(JST['templates/comment'](data))

addOnAddCommetLinkListener = ->
  $('body').on 'click', '.add-comment-link', (e) ->
    e.preventDefault()
    $(@).hide()
    commentableId = $(@).data('commentableId')
    commentableClass = $(@).data('commentableClass')
    addCommentEl = $("#add-comment-to-#{commentableClass}-#{commentableId}")
    addCommentEl.children('form').show()

addOnAjaxResponseForFormListener = ->
  $('body').on 'ajax:success', 'form.new_comment', (e, data, status, xhr) ->
    data = $.parseJSON(xhr.responseText)
    addCommentEl = $(@).parent()
    addCommentEl.children('.comments').append(JST['templates/comment'](data))
    addCommentEl.find('textarea').val('')
    addCommentEl.find('.comment-errors').empty()
    addCommentEl.children('form').hide()
    addCommentEl.children('.add-comment-link').show()
  .on 'ajax:error', 'form.new_comment', (e, xhr, status, error) ->
    addCommentEl = $(@).parent()
    commentErrors = addCommentEl.find('.comment-errors')
    commentErrors.empty()
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, error) ->
      commentErrors.append(error)

ready = ->
  subscribeToComments()
  addOnAddCommetLinkListener()
  addOnAjaxResponseForFormListener()

$(document).on('turbolinks:load', ready)
