extends Control

@export var play_drop_zone_scene: PackedScene

signal player_card_played(card: Card)

var plays := []
var next_play_number := 0

func _ready() -> void:
	var play := $HBoxContainer/CenterContainer/Control
	plays.append(play)
	var play2 := $HBoxContainer/CenterContainer2/Control
	plays.append(play2)
	var play3 := $HBoxContainer/CenterContainer3/Control
	plays.append(play3)
	add_play()


func add_play() -> void:
	if next_play_number < len(plays):
		var next_play_pos: Control = plays[next_play_number]
		var play_drop_zone := play_drop_zone_scene.instantiate()
		play_drop_zone.player_card_played.connect(self._on_play_drop_zone_player_card_played)
		next_play_pos.add_child(play_drop_zone)
		next_play_number += 1

func _on_play_drop_zone_player_card_played(card: Card) -> void:
	player_card_played.emit(card)
