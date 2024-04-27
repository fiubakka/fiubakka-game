extends NinePatchRect

signal start_truco(opponent_id: String)

@onready var timer := $Timer
var id := ""

func _ready() -> void:
	var producer_start_truco_handler: Callable = (
		get_node("/root/Main/ServerConnection/ServerProducer")._on_player_start_truco
	)
	if !start_truco.is_connected(producer_start_truco_handler):
		start_truco.connect(producer_start_truco_handler)

func toggle_popup() -> void:
	visible = true
	timer.start()
	
func _on_button_pressed() -> void:
	start_truco.emit(id)
	visible = false

func _on_timer_timeout() -> void:
	visible = false
