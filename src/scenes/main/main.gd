extends Node2D

const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const Room200Scene = preload("res://src/scenes/maps/room_200/room_200.tscn")

var entities: Dictionary = {}


func _process(_delta: float) -> void:
	if Input.is_action_pressed("open_chat") and !$Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = true
		$Player/Chatbox.focus_chat()
	if Input.is_action_pressed("close_chat") and $Player/Chatbox.visible and !$Player/Chatbox.idle:
		$Player/Chatbox.visible = false


func _on_server_consumer_user_init_ready(_position: Vector2) -> void:
	add_child(Room200Scene.instantiate())
	#TODO: Is it okay to change the initial position of the player like this or should we use something else
	# like signals for example?
	var player := $Room200/Player
	player.update_movement.connect($ServerConnection/ServerProducer._on_player_movement)
	player.position = _position
	$Login.queue_free()
	# $Player/Chatbox.idle = false


func _on_server_consumer_update_entity_state(
	entityId: String, entityPosition: Vector2, entityVelocity: Vector2
) -> void:
	if entities.has(entityId):
		var entity: Node = entities[entityId]
		entity.position = entityPosition
		entity.velocity = entityVelocity
	else:
		var entity := EntityScene.instantiate()
		entity.id = entityId
		entity.position = entityPosition
		entity.velocity = entityVelocity
		entity.player_name = entityId
		entities[entityId] = entity
		$Room200.add_child(entity)
