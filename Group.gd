extends HBoxContainer


export (PackedScene) var Fan


var selected = false setget set_selected

var fan_count
var index

signal group_selected
signal group_consumed


func _process(_delta):
	# TODO: Change this to be a border around the selected maybe
	if selected:
		set_modulate(Color(1.0, 1.0, 1.0, 1.0))
	else:
		set_modulate(Color(1.0, 1.0, 1.0, 0.5))


func _ready():
	randomize()
	
	fan_count = random_fan_count()
	
	for _i in range(fan_count):
		var fan = Fan.instance()
		add_child(fan)


func _input(_event):
	var relevant_input_action
	
	if index == 0:
		relevant_input_action = Input.is_action_just_pressed("select_group_1")
	if index == 1:
		relevant_input_action = Input.is_action_just_pressed("select_group_2")
	if index == 2:
		relevant_input_action = Input.is_action_just_pressed("select_group_3")
	
	if relevant_input_action:
		set_selected(not selected)


func _on_Group_gui_input(_event):
	if Input.is_action_just_pressed("select_group"):
		set_selected(not selected)


# For when this group is placed in seats
func consume():
	Gamestate.current_selected_group = null
	emit_signal("group_consumed")
	queue_free()


func set_selected(new_value):
	selected = new_value
	if selected:
		emit_signal("group_selected")
		Gamestate.current_selected_group = self
	else:
		Gamestate.current_selected_group = null


# Pick random number between 1 and 3
func random_fan_count():
	# I'm doing a range from 0.5 to 3.5 because I 
	# think that gives each number 1, 2, or 3 an equal chance
	return round(rand_range(0.5, 3.5))
