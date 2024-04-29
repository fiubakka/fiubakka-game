extends Node2D

class_name TurnDropZones

signal player_card_played(card: Card)


func _on_player_drop_zone_player_card_played(card: Card) -> void:
	player_card_played.emit(card)


func clean() -> void:
	$PlayerDropZone.deselect()


func player_wins(wins: bool) -> void:
	if wins:
		$PlayerDropZone.change_card_index(2)
		$OpponentDropZone.change_card_index(1)
	else:
		$PlayerDropZone.change_card_index(1)
		$OpponentDropZone.change_card_index(2)
