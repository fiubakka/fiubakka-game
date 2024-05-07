extends Node

signal unpaused

var waiting_for_login: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NinePatchRect/NinePatchRect/RichTextLabel.text = Utils.center_text(tr("OPTION_CONTINUE"))
	$NinePatchRect/NinePatchRect2/RichTextLabel.text = Utils.center_text(tr("OPTION_QUIT"))


func _on_main_login_ready() -> void:
	self.waiting_for_login = false


func _on_continue_pressed() -> void:
	if !waiting_for_login:
		unpaused.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
