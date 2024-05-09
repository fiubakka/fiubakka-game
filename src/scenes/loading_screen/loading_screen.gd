class_name LoadingScreen extends CanvasLayer

signal transition_in_complete
signal spin_logo

@onready var progress_bar: ProgressBar = $Control/VBoxContainer/ProgressBar
@onready var loading_message: RichTextLabel = $Control/VBoxContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var starting_animation: String


func _ready() -> void:
	loading_message.text = Utils.center_text(tr("LOADING_SERVER"))
	progress_bar.visible = false


func start_transition() -> void:
	starting_animation = "fade_to_black"
	animation_player.play(starting_animation)
	spin_logo.emit()


func finish_transition() -> void:
	if timer:
		timer.stop()
	var ending_animation := starting_animation.replace("to", "from")
	if !animation_player.has_animation(ending_animation):
		push_warning("'%s' animation does not exist" % ending_animation)
		ending_animation = "fade_from_black"
	animation_player.play(ending_animation)
	update_bar(100)
	await animation_player.animation_finished
	queue_free()


func update_bar(val: float) -> void:
	progress_bar.value = val


func _on_timer_timeout() -> void:
	progress_bar.visible = true


func loading_level_message() -> void:
	timer.start()
	loading_message.text = Utils.center_text(tr("LOADING_LEVEL"))
