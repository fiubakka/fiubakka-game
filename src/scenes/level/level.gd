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
	var gui_show_npc_tip_signal_handler: Callable = (
		get_node("/root/Main/GUI/GuiManager")._on_npc_tip
	)
	if !player.show_tip.is_connected(gui_show_npc_tip_signal_handler):
		player.show_tip.connect(gui_show_npc_tip_signal_handler)
	$Player/Camera2D.limit_right = MapsDictionary.MAP_LIMITS[PlayerInfo.current_map].w
	$Player/Camera2D.limit_bottom = MapsDictionary.MAP_LIMITS[PlayerInfo.current_map].h
	#TODO: El zoom tarda en hacerse, ver como arreglarlo
	if PlayerInfo.current_map == 1 || PlayerInfo.current_map == 3:
		#This is because the camera size is bigger than the maps comedor and room200
		#so it makes a strange movement when going to the edges
		#We increase the zoom because it is the only way to "shrink" the camera and avoid that strange movement
		$Player/Camera2D.zoom.x = 1.5
		$Player/Camera2D.zoom.y = 1.5
	player.enable()
	connect_doors()


func _on_player_entered_door(player_from_prev_level: Player) -> void:
	disconnect_doors()
	player.disable()
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
