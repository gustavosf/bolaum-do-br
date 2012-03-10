@isNumber = (n) ->
  !isNaN(parseFloat(n)) && isFinite(n)

class @Notification
  success: (message, title) ->
    this.generate('success', message, title)

  warning: (message, title) ->
    this.generate('warning', message, title)

  error: (message, title) ->
    this.generate('error', message, title)

  info: (message, title) ->
    this.generate('info', message, title)

  generate: (type, message, title) ->
    $('<div class="alert alert-' + type + '" data-dismiss="alert"><strong>' + (if title then title else '') + '</strong>' + message + '</div>')
        .appendTo('#notification-area')
        .hide()
        .fadeIn()
        .delay(2000)
        .fadeOut()