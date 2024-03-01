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
	#player.disable()
	#player.visible = false
	pass
	  
func enter_level() -> void:
	player.enable() # define in Player.gd
	connect_doors()
	
func _on_player_entered_door(door: Door) -> void:
	disconnect_doors()
	player.disable()
	player.queue_free()
	set_process(false)

func connect_doors() -> void:
	for door in doors:
		if not door.player_entered_door.is_connected(_on_player_entered_door):
			door.player_entered_door.connect(_on_player_entered_door)
	
func disconnect_doors() -> void:
	for door in doors:
			if door.player_entered_door.is_connected(_on_player_entered_door):
				door.player_entered_door.disconnect(_on_player_entered_door)


