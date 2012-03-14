# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.tabbable > ul > li a').click (event) ->
    return if $(event.target).parent().hasClass 'active'
    link = $(event.target).attr 'data-content'
    console.log link
    $.post '/' + link, (data) -> $('#pane').html data

  $.post '/rodada', (data) ->
    $('#rodada').html data
    $('#rodada input').keypress (event)->
      value = String.fromCharCode(event.which)
      return false if !isNumber(value) 
      $(event.target).val(value)

      game = $(event.target).parents('.jogo')
      game_id = game.attr('ref')
      score_board = game.find('input')
      score = [score_board[0].value, score_board[1].value]
      if isNumber(score[0]) and isNumber(score[1])
        req = $.post '/bet.json', {'bet': score, 'game_id': game_id}, (data) ->
          if data.error? 
            new Notification().error(data.message)
            score_board[0].value = data.score[0]
            score_board[1].value = data.score[1]
          else
            new Notification().success(data.message)
        'json'
