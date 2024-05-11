extends Node

signal unpaused

var waiting_for_login: bool = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_main_login_ready() -> void:
	self.waiting_for_login = false


func _on_continue_pressed() -> void:
	if !waiting_for_login:
		unpaused.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
