extends Node

const Producer = preload("res://src/objects/server/producer/producer.gd")

const PBPlayerInit = preload("res://src/protocol/compiled/client/init/player_init.gd").PBPlayerInit
const PBPlayerMovement = (
	preload("res://src/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)

var _producer: Producer


func start(producer: Producer) -> void:
	_producer = producer


func stop() -> void:
	pass


func _on_player_movement(velocity: Vector2, position: Vector2) -> void:
	var player_movement := PBPlayerMovement.new()
	var player_velocity := player_movement.new_velocity()
	var player_position := player_movement.new_position()
	player_velocity.set_x(velocity.x)
	player_velocity.set_y(velocity.y)
	player_position.set_x(position.x)
	player_position.set_y(position.y)
	_producer.send(player_movement)


func _on_login_user_logged_in(username: String) -> void:
	var player_init := PBPlayerInit.new()
	player_init.set_username(username)
	_producer.send(player_init)
