extends Node


var current_selected_group

var score = 0

var game_over = false

func place_group():
	current_selected_group.consume()
