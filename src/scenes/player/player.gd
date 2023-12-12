extends Area2D

signal change_velocity

@export var idle: bool = false
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var velocity = Vector2.ZERO # The player's movement vector.
var prev_vel = Vector2.ZERO
var id = null


# Called when the node enters the scene tree for the first time.
func _ready():
	#$TCPPeer.update_player_pos.connect(_on_tcp_peer_update_player_pos)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("open_chat")):
		idle = true
	if (Input.is_action_just_pressed("close_chat")):
		idle = false
	if (idle): return
	
	if (Input.is_action_just_pressed("move_right")):
		velocity.x = 1
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	if (Input.is_action_just_pressed("move_left")):
		velocity.x = -1
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
	if (Input.is_action_just_pressed("move_up")):
		velocity.y = -1
		velocity = velocity.normalized()
		change_velocity.emit(velocity)
		$AnimatedSprite2D.play("walk_up")
	if (Input.is_action_just_pressed("move_down")):
		velocity.y = 1
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
		
	prev_vel = velocity

func _on_main_set_player_id(id):
	self.id = id


func _on_tcp_peer_update_player_pos(position):
	self.position = position
