# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.tabbable > ul > li a').click ->
    return if $(event.target).parent().hasClass 'active'
    link = $(event.target).attr 'data-content'
    console.log link
    $.post '/' + link, (data) -> $('#pane').html data

  $.post '/rodada', (data) ->
    $('#rodada').html data
    $('#rodada input').keyup ->
      game = $(event.target).parents('.jogo')
      game_id = game.attr('ref')
      score = game.find('input')
      score = [score[0].value, score[1].value]
      if isNumber(score[0]) and isNumber(score[1])
        game = 
        $.post '/bet', {'bet': score, 'game_id': game_id}, -> new Notification().success('Jogo Salvo')