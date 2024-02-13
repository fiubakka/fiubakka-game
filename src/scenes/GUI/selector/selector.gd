extends HBoxContainer

signal next
signal prev

@export var label: String


func _ready() -> void:
	$Label/RichTextLabel.text = "[center]" + tr(label) + "[/center]"


func _on_prev_button_pressed() -> void:
	prev.emit()


func _on_next_button_pressed() -> void:
	next.emit()
