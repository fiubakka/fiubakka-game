class_name TrucoPlayUpdateDto

var play_id: int
var player_cards: Array[Card]
var game_over: bool
var match_over: bool
var first_points: int
var first_name: String
var second_points: int
var second_name: String
var is_play_card_available: bool
var available_shouts: Array

func _init(
	_play_id: int,
	_player_cards: Array[Card],
	_game_over: bool,
	_match_over: bool,
	_first_points: int,
	_first_name: String,
	_second_points: int,
	_second_name: String,
	_is_play_card_available: bool,
	_available_shouts: Array
) -> void:
	play_id = _play_id
	player_cards = _player_cards
	game_over = _game_over
	match_over = _match_over
	first_points = _first_points
	first_name = _first_name
	second_points = _second_points
	second_name = _second_name
	is_play_card_available = _is_play_card_available
	available_shouts = _available_shouts
