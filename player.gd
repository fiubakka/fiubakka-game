extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

var velocity = Vector2.ZERO # The player's movement vector.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$UDPPeer.init_pos(position, screen_size)


func _input(event):
	if (event.is_action_pressed("move_right")): 
		velocity.x = 1
	
	if (event.is_action_pressed("move_left")):
		velocity.x = -1
		
	if (event.is_action_pressed("move_up")):
		velocity.y = -1
		
	if (event.is_action_pressed("move_down")):
		velocity.y = 1
		
	if (event.is_action_released("move_right") or 
		event.is_action_released("move_left")):
		velocity.x = 0
		
	if (event.is_action_released("move_up") or event.is_action_released("move_down")):
		velocity.y = 0
		
	velocity = velocity.normalized()
	$UDPPeer.change_velocity(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_udp_peer_new_pos(new_position):
	position = new_position
	
