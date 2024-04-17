extends Control

@onready var label := $RichTextLabel
@onready var timer := $Timer
@onready var tween: Tween

func show_tip(message: String) -> void:
	tween = create_tween()
	label.text = message
	visible = true
	tween.tween_property(label, "visible_ratio", 1.0, 1.0).from(0.0)
	timer.start()


func _on_timer_timeout() -> void:
	visible = false
