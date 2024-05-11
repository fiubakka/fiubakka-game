extends HBoxContainer

signal next
signal prev

@export var label: String


func _ready() -> void:
	$Label/RichTextLabel.text = Utils.center_text(tr(label))


func _on_prev_button_pressed() -> void:
	prev.emit()


func _on_next_button_pressed() -> void:
	next.emit()


func _on_language_select_switch_locale() -> void:
	$Label/RichTextLabel.text = Utils.center_text(tr(label))
