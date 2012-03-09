@select_user = (user, el) ->
	for sibling in $(el).siblings()
		do (sibling) ->
			$(sibling).hide()

	console.log user
	$('#user_id').val user
	$('#password-container').show()
	$('#password').focus()