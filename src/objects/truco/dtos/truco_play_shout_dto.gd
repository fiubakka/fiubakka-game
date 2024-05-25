class_name TrucoPlayShoutDto

var play_id: int
var shout: int
var game_over: bool
var match_over: bool
var is_play_card_available: bool
var available_shouts: Array
var first_name: String
var first_points: int
var second_points: int


func _init(
	_play_id: int,
	_shout: int,
	_game_over: bool,
	_match_over: bool,
	_is_play_card_available: bool,
	_available_shouts: Array,
	_first_name: String,
	_first_points: int,
	_second_points: int,
) -> void:
	play_id = _play_id
	shout = _shout
	game_over = _game_over
	match_over = _match_over
	is_play_card_available = _is_play_card_available
	available_shouts = _available_shouts
	first_name = _first_name
	first_points = _first_points
	second_points = _second_points
