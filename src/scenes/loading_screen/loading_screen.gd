class_name LoadingScreen extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var starting_animation: String

func start_transition() -> void:
	# TODO: only has one animation. Add more if necessary
	starting_animation = 'fade_to_black'
	animation_player.play(starting_animation)
	timer.start()
	
func finish_transition() -> void:
	if timer:
		timer.stop()
	var ending_animation := starting_animation.replace('to', 'from')
	if !animation_player.has_animation(ending_animation):
		push_warning("'%s' animation does not exist" % ending_animation)
		ending_animation = 'fade_from_black'
	animation_player.play(ending_animation)
	await animation_player.animation_finished
	queue_free()
