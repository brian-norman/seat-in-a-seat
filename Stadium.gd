extends Control


export (PackedScene) var Row

const ROW_SPACING = 16
const STADIUM_SCROLL_SPEED = 0.5


func _ready():
	var row = Row.instance()
	add_child(row)
	row.connect("row_consumed", self, "on_row_consumed", [row])
	row.rect_position = Vector2(0, 1080 - 1 * row.rect_size.y)


func _process(_delta):
	for child in get_children():
		if child.is_in_group("stadium_row"):
			child.rect_position = Vector2(child.rect_position.x, child.rect_position.y - STADIUM_SCROLL_SPEED)
			if child.rect_position.y < 0:
				Gamestate.game_over = true


func _on_Timer_timeout():
	var row = Row.instance()
	row.connect("row_consumed", self, "on_row_consumed", [row])
	
	var lowest_child = get_child(get_child_count()-1)
	var y
	if lowest_child.is_in_group("stadium_row"):
		y = lowest_child.rect_position.y + lowest_child.rect_size.y
	else:
		y = 1080 - 1 * row.rect_size.y
	
	row.rect_position = Vector2(0, y + ROW_SPACING)
	
	add_child(row)


func on_row_consumed(row):
	for child in get_children():
		if child.is_in_group("stadium_row"):
			if child == row:
				break
			
			child.rect_position = Vector2(0, child.rect_position.y + child.rect_size.y + ROW_SPACING)
