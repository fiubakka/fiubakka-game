extends Control

var timer: Timer

signal user_logged_in(username: String, password: String)
signal return_to_menu


func _on_login_username_text_submitted(username: String) -> void:
	#TODO: Apply same behavior when clicking button or pressing Enter
	if username.is_empty():
		return
	timer = Timer.new()  #This timer is to send the init message until we get a response from the server
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username))
	add_child(timer)
	timer.start()
	timer.set_wait_time(2.0)


func _on_button_pressed() -> void:
	$NinePatchRect/VBoxContainer/Username/UsernameErrorText.visible = false
	$NinePatchRect/VBoxContainer/Password/PasswordErrorText.visible = false
	var username: String = $NinePatchRect/VBoxContainer/Username/LoginUsername.text
	if username.is_empty():
		$NinePatchRect/VBoxContainer/Username/UsernameErrorText.visible = true
		return

	var password: String = $NinePatchRect/VBoxContainer/Password/LoginPassword.text
	if password.is_empty():
		$NinePatchRect/VBoxContainer/Password/PasswordErrorText.visible = true
		return

	#TODO: Show error if there is no username or password

	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username, password))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()
	#TODO: Stop timer once we receive response or return back to menu


func _on_timer_timeout(username: String, password: String) -> void:
	user_logged_in.emit(username, password, null)


func _on_return_return_to_menu() -> void:
	$NinePatchRect/VBoxContainer/Username/LoginUsername.clear()
	return_to_menu.emit()
