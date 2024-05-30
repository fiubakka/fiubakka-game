class_name Level extends Node

@export var player: Player
@export var doors: Array[Door]
@export var limit_bottom: int
@export var limit_right: int
@export var zoom: float = 1

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
	if data.has("entry_door_name"):
		_init_player_location(data["entry_door_name"])
	var producer_movement_signal_handler: Callable = (
		get_node("/root/Main/ServerConnection/ServerProducer")._on_player_movement
	)
	if !player.update_movement.is_connected(producer_movement_signal_handler):
		player.update_movement.connect(producer_movement_signal_handler)
	var gui_show_npc_tip_signal_handler: Callable = (
		get_node("/root/Main/GUI/GuiManager")._on_npc_tip
	)
	if !player.show_tip.is_connected(gui_show_npc_tip_signal_handler):
		player.show_tip.connect(gui_show_npc_tip_signal_handler)
	$Player/Camera2D.limit_right = limit_right
	$Player/Camera2D.limit_bottom = limit_bottom
	$Player/Camera2D.zoom.x = zoom
	$Player/Camera2D.zoom.y = zoom
	player.enable()
	connect_doors()


func _init_player_location(entry_door_name: String) -> void:
	for door in doors:
		if door.name == entry_door_name:
			player.position = door.get_player_entry_position()


func _on_player_entered_door(door: Door, equipment: Equipment) -> void:
	disconnect_doors()
	player.disable()
	data = {"player_equipment": equipment, "entry_door_name": door.entry_door_name}
	set_process(false)


func connect_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)


func disconnect_doors() -> void:
	for door in doors:
		if door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.disconnect(_on_player_entered_door)
