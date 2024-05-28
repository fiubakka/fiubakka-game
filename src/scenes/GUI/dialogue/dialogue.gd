extends Control

signal show_npc_tip(name: String, message: String, equipment: Equipment)

@onready var timer := $Timer


func show_tip(name: String, message: String, equipment: Equipment) -> void:
	show_npc_tip.emit(name, message, equipment)
	visible = true
	timer.start()
	

func _on_timer_timeout() -> void:
	visible = false
