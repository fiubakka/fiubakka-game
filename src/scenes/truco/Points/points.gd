extends Control

class_name Points

var matches_set := []

func _ready() -> void:
	for child: Panel in $HBoxContainer.get_children():
		matches_set.append(child.get_children()[0])

	set_points(19)

func set_points(n: int) -> void:
	if n < 0 or n > 30:
		return
	
	if n <= 15:
		var full_sets: int =  n / 5
		var remainder_points := n % 5
		
		for i in range(len(matches_set)):
			var match_node: Matches = matches_set[i]
			
			if i < full_sets:
				match_node.set_points(5, false)
			elif i == full_sets and remainder_points > 0:
				match_node.set_points(remainder_points, false)
			else:
				match_node.set_points(0, false)
	
	else:
		var full_sets: int = (n - 15) / 5
		var remainder_points := (n - 15) % 5
		
		for i in range(len(matches_set)):
			var match_node: Matches = matches_set[i]
			
			if i < full_sets:
				match_node.set_points(5, true)
			elif i == full_sets and remainder_points > 0:
				match_node.set_points(remainder_points, true)
			else:
				match_node.set_points(5, false)
