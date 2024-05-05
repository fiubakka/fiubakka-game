extends Control

class_name Board

@export var play_drop_zone_scene: PackedScene

signal player_card_played(card: Card)

var turns: Array[TurnDropZones] = []
var turns_pos := []
var next_play_number := 0


func _ready() -> void:
	var turn_pos := $HBoxContainer/CenterContainer/Control
	turns_pos.append(turn_pos)
	var turn_pos2 := $HBoxContainer/CenterContainer2/Control
	turns_pos.append(turn_pos2)
	var turn_pos3 := $HBoxContainer/CenterContainer3/Control
	turns_pos.append(turn_pos3)


# Removes TurnDropZones from the board (and also player and opponent DropZones
func clean() -> void:
	for turn: TurnDropZones in turns:
		turn.queue_free()
	turns = []
	next_play_number = 0


func create_dropzones() -> void:
	for i in range(0, 3):
		next_turn()


func next_turn() -> void:
	if next_play_number < len(turns_pos):
		var next_turn_pos: Control = turns_pos[next_play_number]
		var turn_drop_zone := play_drop_zone_scene.instantiate()
		turns.append(turn_drop_zone)
		turn_drop_zone.player_card_played.connect(self._on_play_drop_zone_player_card_played)
		next_turn_pos.add_child(turn_drop_zone)
		next_play_number += 1


func _on_play_drop_zone_player_card_played(card: Card) -> void:
	player_card_played.emit(card)


func player_wins(wins: bool) -> void:
	var last_turn := len(turns) - 1
	turns[last_turn].player_wins(wins)


func enable_play_zone() -> void:
	for turn in turns:
		if not turn.is_play_zone_enabled():
			turn.enable_play_zone()
			return
			
func disable_play_zone() -> void:
	for i in range (len(turns) - 1, -1, -1):
		var turn := turns[i]
		if turn.is_play_zone_enabled():
			turn.disable_play_zone()
			return
