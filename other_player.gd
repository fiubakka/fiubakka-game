extends Area2D

@export var id = 1
var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (velocity.x > 0):
		$AnimatedSprite2D.play("walk_right")
	elif (velocity.x < 0):
		$AnimatedSprite2D.play("walk_left")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("walk_up")
	elif (velocity.y < 0):
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.play("idle_front")
