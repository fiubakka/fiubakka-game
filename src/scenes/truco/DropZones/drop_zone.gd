extends Node2D

class_name DropZone

var has_card := false
var card: Card = null
var is_enabled := false

signal player_card_played(card: Card)


func select(_card: Card) -> void:
	has_card = true
	card = _card
	if self in get_tree().get_nodes_in_group("table"):
		player_card_played.emit(_card)


func deselect() -> void:
	has_card = false
	card = null


func change_card_index(index: int) -> void:
	if card:
		card.z_index = index
