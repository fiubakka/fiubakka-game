extends Node

signal set_player_id
signal update_player_pos
signal change_velocity

@export var other_placer_scene: PackedScene

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = $Player.get_viewport_rect().size
	$UDPPeer.init_pos($Player.position, screen_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_udp_peer_set_player_id(id):
	set_player_id.emit(id)


func _on_udp_peer_update_player_pos(new_position):
	update_player_pos.emit(new_position)


func _on_player_change_velocity(velocity):
	change_velocity.emit(velocity)


func _on_udp_peer_create_other_player(id, position):
	var other_player = other_placer_scene.instantiate()
	other_player.id = id
	other_player.position = position
	add_child(other_player)
