extends Area2D

@export var id = 1
var velocity = Vector2(0,0)
var prev_vel = Vector2(0,0)
var player_name = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Name.text = "[center][color=#ffaaaa]" + player_name + "[/color][/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
