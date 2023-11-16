extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var velocity = Vector2.ZERO # The player's movement vector.

var id = null

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$UDPPeer.init_pos(position, screen_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_just_pressed("move_right")):
		velocity.x = 1
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
	if (Input.is_action_just_pressed("move_left")):
		velocity.x = -1
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
	if (Input.is_action_just_pressed("move_up")):
		velocity.y = -1
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
	if (Input.is_action_just_pressed("move_down")):
		velocity.y = 1
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
		
		
	if (Input.is_action_just_released("move_right") or 
		Input.is_action_just_released("move_left")):
		velocity.x = 0
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
	if (Input.is_action_just_released("move_up") or 
		Input.is_action_just_released("move_down")):
		velocity.y = 0
		velocity = velocity.normalized()
		$UDPPeer.change_velocity(velocity)
		


func _on_udp_peer_new_pos(new_position):
	position = new_position


func _on_udp_peer_set_player_id(new_id):
	id = new_id
