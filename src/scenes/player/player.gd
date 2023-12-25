extends CharacterBody2D

signal update_movement

@export var idle: bool = false
var screen_size # Size of the game window.
var prev_vel = Vector2.ZERO
var id = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#$TCPPeer.update_player_pos.connect(_on_tcp_peer_update_player_pos)
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (Input.is_action_just_pressed("open_chat")):
		idle = true
	if (Input.is_action_just_pressed("close_chat")):
		idle = false
	if (idle): return
	
	velocity = Vector2.ZERO
	if (Input.is_action_pressed("move_right")):
		velocity.x = 1
	if (Input.is_action_pressed("move_left")):
		velocity.x = -1
	if (Input.is_action_pressed("move_up")):
		velocity.y = -1
	if (Input.is_action_pressed("move_down")):
		velocity.y = 1
		
	if (Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")):
		velocity.x = 0
	if (Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up")):
		velocity.y = 0
	if (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		velocity.x = 0
		
	var next_position: Vector2 = self.position
	
	if (velocity != Vector2.ZERO):
		velocity = velocity.normalized() * 4
		var collision = move_and_collide(velocity, true)
		var remainder_distance = Vector2.ZERO
		if (collision != null):
			velocity = velocity.slide(collision.get_normal())
			remainder_distance = collision.get_travel()
			# If we collided again it means we are in a corner / intersection. Don't move.
			if (move_and_collide(velocity, true) != null):
				velocity = Vector2.ZERO
				remainder_distance = Vector2.ZERO
		next_position = self.position + remainder_distance + velocity
		
	# State changed, notify the server
	if (self.position != next_position or velocity != prev_vel):
		update_movement.emit(velocity, next_position)
		
	self.position = next_position
		
	if (velocity != prev_vel):
		play_move_animation(velocity, prev_vel)
		prev_vel = velocity

func play_move_animation(velocity, prev_vel):
	if (velocity.x > 0):
		$AnimatedSprite2D.play("walk_right")
	elif (velocity.x < 0):
		$AnimatedSprite2D.play("walk_left")
	elif (velocity.y < 0):
		$AnimatedSprite2D.play("walk_back")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("walk_front")
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
