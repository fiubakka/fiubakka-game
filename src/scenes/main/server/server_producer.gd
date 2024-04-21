extends Node

const Producer = preload("res://src/objects/server/producer/producer.gd")

const PBPlayerLogin = (
	preload("res://addons/protocol/compiled/client/init/player_login.gd").PBPlayerLogin
)

const PBPlayerRegister = (
	preload("res://addons/protocol/compiled/client/init/player_register.gd").PBPlayerRegister
)
const PBPlayerMovement = (
	preload("res://addons/protocol/compiled/client/movement/player_movement.gd").PBPlayerMovement
)

const PBPlayerMessage = (
	preload("res://addons/protocol/compiled/client/chat/message.gd").PBPlayerMessage
)

const PBPlayerChangeMap = (
	preload("res://addons/protocol/compiled/client/map/change_map.gd").PBPlayerChangeMap
)

const PBPlayerUpdateEquipment = (
	preload("res://addons/protocol/compiled/client/inventory/update_equipment.gd")
	. PBPlayerUpdateEquipment
)

const PBTrucoMatchChallenge = (
	preload("res://addons/protocol/compiled/client/truco/match_challenge.gd").PBTrucoMatchChallenge
)

const PBTrucoMatchChallengeReply = (
	preload("res://addons/protocol/compiled/client/truco/match_challenge_reply.gd")
	.
	PBTrucoMatchChallengeReply
)

const PBTrucoMatchChallengeReplyEnum = (
	preload("res://addons/protocol/compiled/client/truco/match_challenge_reply.gd")
	.
	PBTrucoMatchChallengeReplyEnum
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
	if equipment:
		var player_register := PBPlayerRegister.new()
		player_register.set_username(username)
		player_register.set_password("password")
		var player_equipment := player_register.new_equipment()
		player_equipment.set_hat(equipment.hat)
		player_equipment.set_hair(equipment.hair)
		player_equipment.set_eyes(equipment.eyes)
		player_equipment.set_glasses(equipment.glasses)
		player_equipment.set_facial_hair(equipment.facial_hair)
		player_equipment.set_body(equipment.body)
		player_equipment.set_outfit(equipment.outfit)
		_producer.send(player_register)
	else:
		var player_login := PBPlayerLogin.new()
		player_login.set_username(username)
		player_login.set_password("password")
		_producer.send(player_login)


func _on_chatbox_send_message(message: String) -> void:
	var player_message := PBPlayerMessage.new()
	player_message.set_content(message)
	_producer.send(player_message)


func _on_player_changes_level(level_id: int) -> void:
	var level_change := PBPlayerChangeMap.new()
	level_change.set_new_map_id(level_id)
	_producer.send(level_change)


func _on_inventory_update_equipment(equipment: Equipment) -> void:
	var new_equipment := PBPlayerUpdateEquipment.new()
	new_equipment.set_hat(equipment.hat)
	new_equipment.set_hair(equipment.hair)
	new_equipment.set_glasses(equipment.glasses)
	new_equipment.set_facial_hair(equipment.facial_hair)
	new_equipment.set_outfit(equipment.outfit)
	new_equipment.set_body(equipment.body)
	new_equipment.set_eyes(equipment.eyes)
	_producer.send(new_equipment)
	
func _on_player_start_truco(opponent_id: String) -> void:
	var truco_match_challenge := PBTrucoMatchChallenge.new()
	truco_match_challenge.set_opponent_username(opponent_id)
	_producer.send(truco_match_challenge)

func _on_modal_match_accepted(opponent_id: String) -> void:
	_reply_truco_match(opponent_id, PBTrucoMatchChallengeReplyEnum.ACCEPTED)
	# TODO: temporarily load the truco scene right now
	# this should be removed when we properly receive the very first TrucoPlay
	# message after accepting the match
	SceneManager.load_new_scene("res://src/scenes/truco/truco_manager.tscn")
	# TODO: load content only when we get an accepted match confirmation from the server
	SceneManager._load_content("res://src/scenes/truco/truco_manager.tscn")

func _on_modal_match_rejected(opponent_id: String) -> void:
	_reply_truco_match(opponent_id, PBTrucoMatchChallengeReplyEnum.REJECTED)

func _reply_truco_match(opponent_id: String, status: PBTrucoMatchChallengeReplyEnum) -> void:
	var truco_match_reply := PBTrucoMatchChallengeReply.new()
	truco_match_reply.set_opponent_username(opponent_id)
	truco_match_reply.set_status(status)
	_producer.send(truco_match_reply)
	
