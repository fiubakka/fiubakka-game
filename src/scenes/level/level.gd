class_name Level extends Node

@export var player: Player
@export var doors: Array[Door]
var data := {}


# Generic Level script for all room nodes to extend from
# This script handles:
# - Connecting level doors signals when instantiating this Level
# - Disconecing level doors when exiting this Level
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.disable()
	player.visible = false
	if data.is_empty():
		enter_level()


func enter_level() -> void:
	if data.has("player_equipment"):
		$Player.set_equipment(data["player_equipment"])
	var producer_movement_signal_handler: Callable = (
		get_node("/root/Main/ServerConnection/ServerProducer")._on_player_movement
	)
	if !player.update_movement.is_connected(producer_movement_signal_handler):
		player.update_movement.connect(producer_movement_signal_handler)
	player.enable()
	connect_doors()


func _on_player_entered_door(player_from_prev_level: Player) -> void:
	disconnect_doors()
	player.disable()
	player.queue_free()
	data = {"player_equipment": player_from_prev_level.equipment}
	set_process(false)


func connect_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)


func disconnect_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
