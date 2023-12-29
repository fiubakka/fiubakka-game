extends Node2D

@export var id := 1
var velocity := Vector2(0, 0)
var prev_vel := Vector2(0, 0)
var player_name := ""


func _ready() -> void:
	$Name.text = "[center][color=#ffaaaa]" + player_name + "[/color][/center]"


func _process(_delta: float) -> void:
	if prev_vel == velocity:
		return

	if velocity.x > 0:
		$AnimatedSprite2D.play("walk_right")
	elif velocity.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("walk_back")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("walk_front")
	else:
		if prev_vel.x > 0:
			$AnimatedSprite2D.play("idle_right")
		elif prev_vel.x < 0:
			$AnimatedSprite2D.play("idle_left")
		elif prev_vel.y < 0:
			$AnimatedSprite2D.play("idle_back")
		elif prev_vel.y > 0:
			$AnimatedSprite2D.play("idle_front")

	prev_vel = velocity
