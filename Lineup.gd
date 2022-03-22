extends VBoxContainer


# TODO: What happened here?!
#export (PackedScene) var Group


const NUMBER_OF_GROUPS_IN_LINE = 3


func _ready():
	for i in range(NUMBER_OF_GROUPS_IN_LINE):
		spawn_group(i)
	# Start off with the first group always selected so we can cycle em
	get_child(0).set_selected(true)


func _input(_event):
	if Input.is_action_just_pressed("cycle_group"):
		var next_index = get_next_node_in_cycle()
		if next_index != null:
			get_child(next_index).set_selected(true)


func _on_group_selected(selected_group):
	for group in get_children():
		if group != selected_group:
			group.set_selected(false)


func _on_group_consumed(consumed_index):
	spawn_group(consumed_index)


func spawn_group(i):
	var group = preload("res://Group.tscn").instance()
	group.index = i
	group.connect("group_selected", self, "_on_group_selected", [group])
	group.connect("group_consumed", self, "_on_group_consumed", [i])
	group.set_selected(true)
	add_child(group)
	move_child(group, i)


func get_next_node_in_cycle():
	var selected_index
	for index in get_child_count():
		if get_child(index).selected:
			selected_index = index
	
	if selected_index == null:
		return null
	
	if selected_index == get_child_count() - 1:
		return 0
	else:
		return selected_index + 1
