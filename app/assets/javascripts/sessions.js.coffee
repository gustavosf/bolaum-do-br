@select_user = (user, el) ->
	for sibling in $(el).siblings()
		do (sibling) ->
			$(sibling).hide()

	$('#email').val user
	$('#password-container').show()
	$('#password').focus()