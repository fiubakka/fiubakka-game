extends Control

var timer: Timer

signal user_logged_in(username: String, password: String)
signal return_to_menu


func _ready() -> void:
	$NinePatchRect/VBoxContainer/LoginButtonBorder/LoginText.text = Utils.center_text(tr("LOGIN"))


func _on_login_username_text_submitted(_username: String) -> void:
	self._on_button_pressed()


func _on_login_password_text_submitted(_password: String) -> void:
	self._on_button_pressed()


func show_error_message(errorCode: String) -> void:
	if timer:
		timer.stop()
	$NinePatchRect/VBoxContainer/LoginButtonBorder/LoginErrorText.text = Utils.center_text(
		tr(errorCode)
	)
	$NinePatchRect/VBoxContainer/LoginButtonBorder/LoginErrorText.visible = true


func _on_button_pressed() -> void:
	$NinePatchRect/VBoxContainer/LoginButtonBorder/LoginErrorText.visible = false
	var username: String = $NinePatchRect/VBoxContainer/Username/LoginUsername.text
	if username.is_empty():
		self.show_error_message("EMPTY_USERNAME")
		return

	var password: String = $NinePatchRect/VBoxContainer/Password/LoginPassword.text
	if password.is_empty():
		self.show_error_message("EMPTY_PASSWORD")
		return

	timer = Timer.new()  # Timer to send init message until we get a response
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username, password))
	add_child(timer)
	timer.set_wait_time(2.0)
	timer.start()


func _on_timer_timeout(username: String, password: String) -> void:
	user_logged_in.emit(username, password, null)


func _on_return_return_to_menu() -> void:
	$NinePatchRect/VBoxContainer/LoginButtonBorder/LoginErrorText.visible = false
	$NinePatchRect/VBoxContainer/Username/LoginUsername.clear()
	$NinePatchRect/VBoxContainer/Password/LoginPassword.clear()
	if timer:
		timer.stop()
	return_to_menu.emit()
