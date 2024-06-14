extends Node2D

class_name TurnDropZones

signal player_card_played(card: Card)


func _ready() -> void:
	$OpponentDropZone.is_enabled = true


func _on_player_drop_zone_player_card_played(card: Card, drop_zone: DropZone) -> void:
	if not $PlayerDropZone.is_enabled:
		return
	var has_card := has_card_in_play()
	player_card_played.emit(card)
	if has_card:
		drop_zone.change_card_index(2)


func clean() -> void:
	$PlayerDropZone.deselect()


func player_wins(wins: bool) -> void:
	if wins:
		$PlayerDropZone.change_card_index(2)
		$OpponentDropZone.change_card_index(1)
	else:
		$PlayerDropZone.change_card_index(1)
		$OpponentDropZone.change_card_index(2)


func has_card_in_play() -> bool:
	return $PlayerDropZone.has_card


func enable_play_zone() -> void:
	$PlayerDropZone.is_enabled = true


func disable_play_zone() -> void:
	$PlayerDropZone.is_enabled = false


func is_play_zone_enabled() -> bool:
	return $PlayerDropZone.is_enabled
