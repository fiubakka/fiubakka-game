extends Node2D

class_name Confetti

func start() -> void:
	$Green.restart()
	$Green.emitting = true
	$Red.restart()
	$Red.emitting = true
	$Blue.restart()
	$Blue.emitting = true
