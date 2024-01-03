extends Node

var waiting_for_login: bool = true
var is_paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !waiting_for_login:
		#TODO: Handle case where chat is open and esc key is pressed
		if Input.is_action_just_pressed("pause"):
			self.is_paused = !self.is_paused
			self.visible = !self.visible


func _on_main_login_ready() -> void:
	self.waiting_for_login = false
