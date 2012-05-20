# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@update = (button) ->
  new Notification().info('Atualizando a rodada...')
  $(button).attr 'disabled', 'disabled'
  $.post '/update', (data) ->
    if data.error
      new Notification().error(data.message)
    else
      new Notification().success(data.message)
      setTimeout 'window.location.reload()', 2500
    $(button).attr 'disabled', false
