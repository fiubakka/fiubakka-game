extends Node2D

class_name DropZone

var has_card := false

signal player_card_played(card: Card)


func select(card: Card) -> void:
	has_card = true
	if self in get_tree().get_nodes_in_group("table"):
		player_card_played.emit(card)


func deselect() -> void:
	has_card = false

