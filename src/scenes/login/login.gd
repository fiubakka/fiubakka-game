extends Control

var timer: Timer

signal user_logged_in(username: String)


func _on_login_username_text_submitted(username: String) -> void:
	if username.is_empty():
		return
	timer = Timer.new()  #This timer is to send the init message until we get a response from the server
	timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(username))
	add_child(timer)
	timer.start()
	timer.set_wait_time(2.0)


func _on_timer_timeout(username: String) -> void:
	user_logged_in.emit(username)
