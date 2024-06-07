extends RichTextLabel


func _on_game_over_opponent_abandoned() -> void:
	text = Utils.center_text(tr("TRUCO_OPPONENT_ABANDONED"))
