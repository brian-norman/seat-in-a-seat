extends HBoxContainer


export (PackedScene) var Seat

const NUMBER_OF_SEATS = 8

var seats = []

signal row_consumed


func _ready():
	for i in range(NUMBER_OF_SEATS):
		var seat = Seat.instance()
		add_child(seat)
		seats.append(seat)
		seat.connect("seat_hovered", self, "_on_seat_hovered", [seat, i])
		seat.connect("seat_unhovered", self, "_on_seat_unhovered")


func _process(_delta):
	var all_filled = true
	for seat in seats:
		if not seat.filled:
			all_filled = false
	if all_filled:
		for seat in seats:
			seat.clear()
		if $ClearedTimer.is_stopped():
			$ClearingSound.play()
			$ClearedTimer.start()


func _input(_event):
	if Input.is_action_just_pressed("place_fan") and Gamestate.current_selected_group:
		var placed = false
		for seat in seats:
			if seat.showing_potential_fan:
				seat.filled = true
				seat.showing_potential_fan = false
				placed = true
				$PlacingSound.play()
		if placed:
			Gamestate.place_group()


func _on_seat_hovered(hovered_seat, index):
	if hovered_seat.filled:
		return
	
	if weakref(Gamestate.current_selected_group).get_ref():
		var fan_count = Gamestate.current_selected_group.fan_count
		
		var available_seats = available_seats(fan_count, index)
		if available_seats:
			for seat_index in available_seats:
				seats[seat_index].show_potential_fan()


func _on_seat_unhovered():
	for seat in seats:
		seat.hide_potential_fan()


# Returns the best seat indexes to use for the hovered seat
# Returns empty array if we can't place any fans down
# Assumes current index seat is not filled !!
func available_seats(fan_count, index):
	var available_seats = []
	
	if fan_count == 1:
		available_seats.append(index)
	
	if fan_count == 2:
		if index == 0:
			if not seats[index + 1].filled:
				available_seats.append(index)
				available_seats.append(index + 1)
		elif index < 7:
			if not seats[index + 1].filled:
				available_seats.append(index)
				available_seats.append(index + 1)
			elif not seats[index - 1].filled:
				available_seats.append(index)
				available_seats.append(index - 1)
		else:
			if not seats[index - 1].filled:
				available_seats.append(index)
				available_seats.append(index - 1)
	
	if fan_count == 3:
		if index == 0:
			if not seats[index + 1].filled and not seats[index + 2].filled:
				available_seats.append(index)
				available_seats.append(index + 1)
				available_seats.append(index + 2)
		elif 0 < index and index < 7:
			if not seats[index - 1].filled and not seats[index + 1].filled:
				available_seats.append(index - 1)
				available_seats.append(index)
				available_seats.append(index + 1)
			elif index < 6 and not seats[index + 1].filled and not seats[index + 2].filled:
				available_seats.append(index)
				available_seats.append(index + 1)
				available_seats.append(index + 2)
			elif index > 1 and not seats[index - 2].filled and not seats[index - 1].filled:
				available_seats.append(index - 2)
				available_seats.append(index - 1)
				available_seats.append(index)
		else:
			if not seats[index - 2].filled and not seats[index - 1].filled:
				available_seats.append(index - 2)
				available_seats.append(index - 1)
				available_seats.append(index)
	
	return available_seats


func _on_ClearedTimer_timeout():
	Gamestate.score += 1
	emit_signal("row_consumed")
	queue_free()
