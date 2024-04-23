extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()

func start() -> void:
	$Green.restart()
	$Green.emitting = true
	$Red.restart()
	$Red.emitting = true
	$Blue.restart()
	$Blue.emitting = true
