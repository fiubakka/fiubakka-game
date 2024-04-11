extends Control

@onready var label := $RichTextLabel
@onready var timer := $Timer


func show_tip(message: String) -> void:
	label.text = message
	visible = true
	timer.start()


func _on_timer_timeout() -> void:
	visible = false
