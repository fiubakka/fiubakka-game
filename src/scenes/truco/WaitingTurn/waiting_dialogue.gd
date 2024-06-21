extends Control

@onready var waiting_text := $NinePatchRect/WaitingText

func activate(is_activated: bool) -> void:
	visible = is_activated
	waiting_text.activate(is_activated)
