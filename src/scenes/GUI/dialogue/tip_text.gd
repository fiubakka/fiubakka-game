extends RichTextLabel

@onready var tween: Tween


func _on_dialogue_show_npc_tip(_name: String, message: String, _equipment: Equipment) -> void:
	tween = create_tween()
	text = message
	tween.tween_property(self, "visible_ratio", 1.0, 1.0).from(0.0)
