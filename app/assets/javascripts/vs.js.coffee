# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@update = (button) ->
  new Notification().info('Atualizando a rodada...')
  $(button).attr 'disabled', 'disabled'
  errors = 3
  $.post('/update')
    .success (data) ->
      new Notification().success(data.message)
      setTimeout 'window.location.reload()', 2500
      $(button).attr 'disabled', false
    .error ->
      if (errors--)
        console.log 'retrying...'
        $.post(this)
      else
        new Notification().error('Um erro ocorreu, tente novamente mais tarde')
      $(button).attr 'disabled', false

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

@paginate = ->
  mult = 2
  mult = -2 if $(event.target).text() == "«"
  li = $('.pagination li').slice(1,3)
  a = li.find('a')
  val = [parseInt($(a[0]).text()) + mult, parseInt($(a[1]).text()) + mult]
  
  return if val[1] > 39 or val[1] < 1

  if val[1] == 39 or val[1] == 1
    val[0] += 0.5 * -mult
    val[1] += 0.5 * -mult

  li.removeClass('active')
  $(a[0]).text(val[0])
  $(a[1]).text(val[1])

  actual_round = parseInt($('.pagination').attr('round'))
  $(li[0]).addClass('active') if val[0] == actual_round
  $(li[1]).addClass('active') if val[1] == actual_round

@paginateTo = ->
  to = $(event.target).text()
  location.href = '/vs/rodada/' + to
 