extends Control

func show_tip(message: String) -> void:
	$RichTextLabel.text = message
	visible = true
