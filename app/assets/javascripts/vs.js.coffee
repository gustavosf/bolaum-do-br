# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@update = (button) ->
  new Notification().info('Atualizando a rodada...')
  $(button).attr 'disabled', 'disabled'
  $.post('/update', -> $(button).attr 'disabled', false)
    .success (data) ->
      if data.error
        new Notification().error(data.message)
      else
        new Notification().success(data.message)
        setTimeout 'window.location.reload()', 2500
    .error ->
      new Notification().error('Um erro ocorreu, tente novamente mais tarde')


@showScore = (game) ->
  bet = JSON.parse $(game).attr('bet')
  score = JSON.parse $(game).attr('score')
  bet_div = $(game).find('.score')
  $(bet_div[0]).text(score[0])
  $(bet_div[1]).text(score[1])
  $(bet_div[0]).css('color', 'green') if bet[0] == score[0]
  $(bet_div[1]).css('color', 'green') if bet[1] == score[1]

@hideScore = (game) ->
  bet = JSON.parse $(game).attr('bet')
  bet_div = $(game).find('.score')
  $(bet_div[0]).text(bet[0])
  $(bet_div[1]).text(bet[1])
  $(bet_div).css('color', 'inherit')