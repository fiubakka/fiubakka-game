extends Control

var activated := false
var original_text := ""
var dots_count := 1
@onready var timer := $Timer
@onready var text := $RichTextLabel

func _ready() -> void:
	set_text("Waiting for the opponent's turn")
	activate(true)


func set_text(s: String) -> void:
	original_text = s
	text.text = Utils.center_text(original_text + ".")


func activate(_activated: bool) -> void:
	activated = _activated
	if activated:
		timer.start()
	else:
		timer.stop()


func _on_timer_timeout() -> void:
	if dots_count > 3:
		dots_count = 1
	var string_with_dots := add_dots(original_text, dots_count)
	text.text = Utils.center_text(string_with_dots)
	dots_count += 1


func add_dots(s: String, dots_number: int) -> String:
	var result := s
	for i: int in range(0, dots_count):
		result += "."
	return result
