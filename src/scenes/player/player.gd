extends Area2D

signal change_velocity

@export var idle: bool = true
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var velocity = Vector2.ZERO # The player's movement vector.
var prev_vel = Vector2.ZERO
var id = null

var collision_inputs = {}
var should_update_move_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$TCPPeer.update_player_pos.connect(_on_tcp_peer_update_player_pos)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	should_update_move_counter += delta
	
	if (Input.is_action_just_pressed("open_chat")):
		idle = true
	if (Input.is_action_just_pressed("close_chat")):
		idle = false
	if (idle): return
	
	velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_right") and !(collision_inputs.has("move_right"))):
		velocity.x = 1
	if (Input.is_action_pressed("move_left") and !(collision_inputs.has("move_left"))):
		velocity.x = -1
	if (Input.is_action_pressed("move_up") and !(collision_inputs.has("move_up"))):
		velocity.y = -1
	if (Input.is_action_pressed("move_down") and !(collision_inputs.has("move_down"))):
		velocity.y = 1
		
	if (Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")):
		velocity.x = 0
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	if (Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up")):
		velocity.y = 0
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	if (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		velocity.x = 0
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	
	
	if velocity != Vector2.ZERO and should_update_move_counter > 0.01666:
		should_update_move_counter = 0
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	
	play_move_animation(velocity, prev_vel)
	prev_vel = velocity

func play_move_animation(velocity, prev_vel):
	if (velocity.x > 0):
		$AnimatedSprite2D.play("walk_right")
	elif (velocity.x < 0):
		$AnimatedSprite2D.play("walk_left")
	elif (velocity.y < 0):
		$AnimatedSprite2D.play("walk_up")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("walk_down")
	else:
		if (prev_vel.x > 0):
			$AnimatedSprite2D.play("idle_right")
		elif (prev_vel.x < 0):
			$AnimatedSprite2D.play("idle_left")
		elif (prev_vel.y < 0):
			$AnimatedSprite2D.play("idle_back")
		elif (prev_vel.y > 0):
			$AnimatedSprite2D.play("idle_front")


func _on_main_set_player_id(id):
	self.id = id


func _on_tcp_peer_update_player_pos(position):
	self.position = position


func _on_area_entered(area):
	for i in range(area.get_child_count()):
		var collision_node = area.get_child(i)
		var collision_direction = collision_node.get_meta("collision_direction")
		match int(collision_direction.x):
			1:
				collision_inputs["move_right"] = collision_node
			-1:
				collision_inputs["move_left"] = collision_node
		match int(collision_direction.y):
			1:
				collision_inputs["move_down"] = collision_node
			-1:
				collision_inputs["move_up"] = collision_node
		if (collision_direction.x != 0):
			velocity.x = 0
		if (collision_direction.y != 0):
			velocity.y = 0
		velocity = velocity.normalized()
		change_velocity.emit(velocity)


func _on_area_exited(area):
	for i in range(area.get_child_count()):
		var collision_node = area.get_child(i)
		for key in collision_inputs:
			if (collision_inputs[key] == collision_node):
				collision_inputs.erase(key)
