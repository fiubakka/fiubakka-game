extends Node

const Producer = preload("res://src/objects/server/producer/producer.gd")

const PBPlayerInit = (
	preload("res://addons/protocol/compiled/client/init/player_init.gd").PBPlayerInit
)
const PBPlayerMovement = (
	preload("res://addons/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)

const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/client/chat/message.gd").PBPlayerMessage
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


func _on_user_logged_in(username: String, equipment: Equipment) -> void:
	var player_init := PBPlayerInit.new()
	player_init.set_username(username)
	if equipment:
		var player_equipment := player_init.new_equipment()
		player_equipment.set_hat(equipment.hat)
		player_equipment.set_hair(equipment.hair)
		player_equipment.set_eyes(equipment.eyes)
		player_equipment.set_glasses(equipment.glasses)
		player_equipment.set_facial_hair(equipment.facial_hair)
		player_equipment.set_body(equipment.body)
		player_equipment.set_outfit(equipment.outfit)
	_producer.send(player_init)


func _on_chatbox_send_message(message: String) -> void:
	var player_message := PBPlayerMessage.new()
	player_message.set_content(message)
	_producer.send(player_message)

	
func _on_player_changes_level(level_id: int) -> void:
	var level_change := PBPlayerChangeMap.new()
	level_change.id = level_id
	_producer.send(level_change)
