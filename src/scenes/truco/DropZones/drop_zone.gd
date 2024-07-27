extends Node2D

class_name DropZone

var has_card := false
var card: Card = null
var is_enabled := false

signal player_card_played(card: Card, drop_zone: DropZone)


func _draw() -> void:
	if name == "PlayerDropZone":
		draw_rect(Rect2(-44, -70, 88, 140), Color.DARK_SEA_GREEN)
		draw_rect(Rect2(-40, -66, 80, 132), Color8(26, 92, 70, 255))


func select(_card: Card) -> void:
	has_card = true
	card = _card
	if self in get_tree().get_nodes_in_group("table"):
		player_card_played.emit(_card, self)


func deselect() -> void:
	has_card = false
	card = null


func change_card_index(index: int) -> void:
	if card:
		card.z_index = index
