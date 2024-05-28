extends RichTextLabel


func _on_dialogue_show_npc_tip(name: String, _message: String, _equipment: Equipment) -> void:
	text = Utils.center_text(name)
