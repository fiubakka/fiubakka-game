extends Node2D

class_name TurnDropZones

signal player_card_played(card: Card)


func _on_player_drop_zone_player_card_played(card: Card) -> void:
	player_card_played.emit(card)


func clean() -> void:
	$PlayerDropZone.deselect()
