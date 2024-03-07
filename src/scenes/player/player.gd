extends CharacterBody2D

signal update_movement(velocity: Vector2, position: Vector2)

@export var idle: bool = false
var prev_vel := Vector2.ZERO

var cs := CompositeSprites


func _ready() -> void:
	$Name.text = Utils.center_text("[b]" + tr("OWN_PLAYER_LABEL") + "[/b]")
	# Set idle front animation when spawning player
	set_idle_region()
	$AnimationPlayer.play("front")


func set_equipment(equipment: Equipment) -> void:
	$PlayerSprite/Hats.texture = cs.hats_spritesheet[equipment["hat"]]
	$PlayerSprite/Hair.texture = cs.hair_spritesheet[equipment["hair"]]
	$PlayerSprite/Eyes.texture = cs.eyes_spritesheet[equipment["eyes"]]
	$PlayerSprite/Body.texture = cs.body_spritesheet[equipment["body"]]
	$PlayerSprite/Glasses.texture = cs.glasses_spritesheet[equipment["glasses"]]
	$PlayerSprite/FacialHair.texture = cs.facial_hair_spritesheet[equipment["facial_hair"]]
	$PlayerSprite/Outfit.texture = cs.outfit_spritesheet[equipment["outfit"]]


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if idle:
		return

	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1

	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right"):
		velocity.x = 0
	if Input.is_action_just_released("move_down") or Input.is_action_just_released("move_up"):
		velocity.y = 0
	if Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left"):
		velocity.x = 0

	var next_position: Vector2 = self.position

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * 4
		var collision := move_and_collide(velocity, true)
		var remainder_distance := Vector2.ZERO
		if collision != null:
			velocity = velocity.slide(collision.get_normal())
			remainder_distance = collision.get_travel()
			# If we collided again it means we are in a corner / intersection. Don't move.
			if move_and_collide(velocity, true) != null:
				velocity = Vector2.ZERO
				remainder_distance = Vector2.ZERO
		next_position = self.position + remainder_distance + velocity

	# State changed, notify the server
	if self.position != next_position or velocity != prev_vel:
		update_movement.emit(velocity, next_position)

	self.position = next_position

	if velocity != prev_vel:
		play_move_animation()
		prev_vel = velocity


func play_move_animation() -> void:
	set_walk_region()
	if velocity.x > 0:
		$AnimationPlayer.play("right")
	elif velocity.x < 0:
		$AnimationPlayer.play("left")
	elif velocity.y < 0:
		$AnimationPlayer.play("back")
	elif velocity.y > 0:
		$AnimationPlayer.play("front")
	else:
		set_idle_region()
		if prev_vel.x > 0:
			$AnimationPlayer.play("right")
		elif prev_vel.x < 0:
			$AnimationPlayer.play("left")
		elif prev_vel.y < 0:
			$AnimationPlayer.play("back")
		elif prev_vel.y > 0:
			$AnimationPlayer.play("front")


func set_idle_region() -> void:
	var idle_region_rect := Rect2(0, 120, 1152, 72)
	$PlayerSprite/Body.region_rect = idle_region_rect
	$PlayerSprite/Hair.region_rect = idle_region_rect
	$PlayerSprite/Eyes.region_rect = idle_region_rect
	$PlayerSprite/Outfit.region_rect = idle_region_rect
	$PlayerSprite/FacialHair.region_rect = idle_region_rect
	$PlayerSprite/Glasses.region_rect = idle_region_rect
	$PlayerSprite/Hats.region_rect = Rect2(0, 96, 1152, 72)


func set_walk_region() -> void:
	var walk_region_rect := Rect2(0, 216, 1152, 72)
	$PlayerSprite/Body.region_rect = walk_region_rect
	$PlayerSprite/Hair.region_rect = walk_region_rect
	$PlayerSprite/Eyes.region_rect = walk_region_rect
	$PlayerSprite/Outfit.region_rect = walk_region_rect
	$PlayerSprite/FacialHair.region_rect = walk_region_rect
	$PlayerSprite/Glasses.region_rect = walk_region_rect
	$PlayerSprite/Hats.region_rect = Rect2(0, 190, 1152, 72)


func _on_main_ui_opened(open: bool) -> void:
	if open:
		idle = true
		velocity = Vector2.ZERO
		play_move_animation()
	else:
		idle = false
