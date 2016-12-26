subscribeToComments = ->
  return if App.comments
  App.comments = App.cable.subscriptions.create 'CommentsChannel',
    received: (comment) ->
      return if gon.user_id is comment.user_id
      commentableClass = comment.commentable_type.toLowerCase()
      addCommentEl = $("#add-comment-to-#{commentableClass}-#{comment.commentable_id}")
      addCommentEl.children('.comments').append(JST['templates/comment'](comment))

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
    comment = $.parseJSON(xhr.responseText)
    addCommentEl = $(@).parent()
    addCommentEl.children('.comments').append(JST['templates/comment'](comment))
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
      for field, field_errors of error
        commentErrors.append("#{field} #{field_errors}" for field_error of field_errors)

ready = ->
  subscribeToComments()
  addOnAddCommetLinkListener()
  addOnAjaxResponseForFormListener()

$(document).on('turbolinks:load', ready)
