extends Control

class_name Board

@export var play_drop_zone_scene: PackedScene

signal player_card_played(card: Card)

var turns := []
var turns_pos := []
var next_play_number := 0


func _ready() -> void:
	var turn_pos := $HBoxContainer/CenterContainer/Control
	turns_pos.append(turn_pos)
	var turn_pos2 := $HBoxContainer/CenterContainer2/Control
	turns_pos.append(turn_pos2)
	var turn_pos3 := $HBoxContainer/CenterContainer3/Control
	turns_pos.append(turn_pos3)
	add_play()


func clean() -> void:
	for turn: TurnDropZones in turns:
		turn.clean()


func add_play() -> void:
	if next_play_number < len(turns_pos):
		var next_turn_pos: Control = turns_pos[next_play_number]
		var turn_drop_zone := play_drop_zone_scene.instantiate()
		turns.append(turn_drop_zone)
		turn_drop_zone.player_card_played.connect(self._on_play_drop_zone_player_card_played)
		next_turn_pos.add_child(turn_drop_zone)
		next_play_number += 1

func _on_play_drop_zone_player_card_played(card: Card) -> void:
	player_card_played.emit(card)
