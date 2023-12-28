extends MarginContainer

const v_amplitude := 0.1
const v_frequency := 1
const h_amplitude := 0.1
const h_frequency := 1

var time_passed := 0.


func _process(delta: float) -> void:
	time_passed += delta
	var vertical_offset := sin(time_passed * v_frequency + PI / 2) * v_amplitude
	var horizontal_offset := sin(time_passed * h_frequency - PI / 3) * h_amplitude
	position.x += horizontal_offset
	position.y += vertical_offset
