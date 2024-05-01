extends Control

class_name Points

var matches_set := []


func _ready() -> void:
	for child: Panel in $HBoxContainer.get_children():
		matches_set.append(child.get_children()[0])

	set_points(8)


func set_points(n: int) -> void:
	if n < 0 or n > 30:
		return

	var second_half := n > 15
	var full_sets: int = (n - 15) / 5 if second_half else n / 5
	var remainder_points: int = (n - 15) % 5 if second_half else n % 5
	var remainder_matches: int = 5 if second_half else 0

	for i in range(len(matches_set)):
		var match_node: Matches = matches_set[i]
		if i < full_sets:
			match_node.set_points(5, second_half)
		elif i == full_sets and remainder_points > 0:
			match_node.set_points(remainder_points, second_half)
		else:
			match_node.set_points(remainder_matches, false)
