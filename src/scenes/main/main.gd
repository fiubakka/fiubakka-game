extends Node2D

const LoginScene = preload("res://src/scenes/login/login.tscn")
const CharCreationScene = preload("res://src/scenes/character_creation/character_creation.tscn")
const EntityScene = preload("res://src/scenes/entity/entity.tscn")
const Room200Scene = preload("res://src/scenes/maps/room_200/room_200.tscn")

var entities: Dictionary = {}
var is_game_paused: bool = false

signal login_ready
signal chat_opened
signal chat_closed
signal paused
signal unpaused


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_chat") && !is_game_paused:
		chat_opened.emit()
	elif Input.is_action_just_pressed("close_chat") && !is_game_paused:
		chat_closed.emit()
	elif Input.is_action_just_pressed("pause"):
		self.is_game_paused = true
		paused.emit()


func _on_server_consumer_user_init_ready(_position: Vector2, equipment: Equipment) -> void:
	add_child(Room200Scene.instantiate())
	#TODO: Is it okay to change the initial position of the player like this or should we use something else
	# like signals for example?
	var player := $Room200/Player
	player.update_movement.connect($ServerConnection/ServerProducer._on_player_movement)
	chat_opened.connect(player._on_main_chat_opened)
	chat_closed.connect(player._on_main_chat_closed)
	paused.connect(player._on_main_paused)
	unpaused.connect(player._on_main_unpaused)
	player.set_equipment(equipment)
	player.position = _position
	login_ready.emit()
	$Login.queue_free()


func _on_server_consumer_update_entity_state(
	entityId: String, entityPosition: Vector2, entityVelocity: Vector2, equipment: Equipment
) -> void:
	if entities.has(entityId):
		var entity: Node = entities[entityId]
		entity.position = entityPosition
		entity.velocity = entityVelocity
		entity.set_equipment(equipment)
	else:
		var entity := EntityScene.instantiate()
		entity.id = entityId
		entity.position = entityPosition
		entity.velocity = entityVelocity
		entity.player_name = entityId
		entity.set_equipment(equipment)
		entities[entityId] = entity
		$Room200.add_child(entity)


func _on_pause_unpaused() -> void:
	is_game_paused = false
	unpaused.emit()


func _on_register_save_character() -> void:
	$Register.queue_free()


func _on_main_menu_go_to_login() -> void:
	$Login.visible = true
	$MainMenu.visible = false


func _on_main_menu_go_to_register() -> void:
	$Register.visible = true
	$MainMenu.visible = false


func _on_login_return_to_menu() -> void:
	$MainMenu.visible = true
	$Login.visible = false


func _on_register_return_to_menu() -> void:
	$MainMenu.visible = true
	$Register.visible = false
