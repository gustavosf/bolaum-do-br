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

$.modal = (opt) ->
  opt.header = "Hello"  if opt.header is undefined
  opt.content = "Hello"  if opt.content is undefined
  opt.primary_btn = "Ok"  if opt.primary_btn is undefined
  tmpl = $("<div class=\"modal fade\" id=\"modal-window\">" + "<div class=\"modal-header\">" + "<a class=\"close\" data-dismiss=\"modal\">×</a>" + "<h3>" + opt.header + "</h3>" + "</div>" + "<div class=\"modal-body\"><p>" + opt.content + "</p></div>" + "<div class=\"modal-footer\"></div>" + "</div>")
  if opt.buttons isnt undefined
    footer = tmpl.find(".modal-footer")
    $.each opt.buttons, (i, btn) ->
      btn_el = $("<a href=\"#\" class=\"btn\">")
      btn.type and btn_el.addClass("btn-" + btn.type)
      btn.click and btn_el.on("click", ->
        btn.click tmpl
      )
      btn_el.text btn.text
      footer.prepend btn_el
  tmpl.on "hidden", ->
    tmpl.detach()

  tmpl.modal()