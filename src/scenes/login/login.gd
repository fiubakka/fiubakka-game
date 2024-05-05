extends Control

var timer: Timer

signal user_logged_in(username: String, password: String)
signal return_to_menu
signal login_error(errorCode: String)

var username: String = ""
var password: String = ""


func _on_login_username_text_changed(_username: String) -> void:
	username = _username


func _on_login_password_text_changed(_password: String) -> void:
	password = _password


func _on_login_username_text_submitted(_username: String) -> void:
	self._on_button_pressed()


func _on_login_password_text_submitted(_password: String) -> void:
	self._on_button_pressed()


func _on_login_error(_errorCode: String) -> void:
	if timer:
		timer.stop()


func _on_button_pressed() -> void:
	# $NinePatchRect/VBoxContainer/LoginButtonBorder/LoginErrorText.visible = false
	if username.is_empty():
		login_error.emit("EMPTY_USERNAME")
		return

	if password.is_empty():
		login_error.emit("EMPTY_PASSWORD")
		return

	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout() -> void:
	user_logged_in.emit(username, password, null)


func _on_return_to_menu() -> void:
	username = ""
	password = ""
	if timer:
		timer.stop()
	return_to_menu.emit()


func _on_user_init_error(errorCode: String) -> void:
	login_error.emit(errorCode)
