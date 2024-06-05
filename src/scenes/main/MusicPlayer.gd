extends AudioStreamPlayer

var login_music := preload("res://audio/music/login.ogg")
var main_music := preload("res://audio/music/main.ogg")
var truco_music := preload("res://audio/music/truco.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	login_music.loop = true
	main_music.loop = true
	truco_music.loop = true
	bus = &"MusicMain"
	stream = login_music
	play()


func _on_main_login_ready() -> void:
	stream = main_music
	play()


func _on_start_truco_music() -> void:
	stream = truco_music
	play()
