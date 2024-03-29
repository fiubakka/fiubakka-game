extends DropZone

signal player_card_played(card: Card)

func select(card: Card) -> void:
	has_card = true
	modulate = Color.WEB_MAROON
	player_card_played.emit(card)
