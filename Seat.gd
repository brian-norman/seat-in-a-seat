extends Control


var filled = false

var hovered = false
var showing_potential_fan = false

signal seat_hovered
signal seat_unhovered

const PREFILLED_PROBABILITY = 0.15


func _ready():
	randomize()
	if is_prefilled():
		filled = true
		$Prefilled.visible = true
		$Seat.visible = false
		$Fan.visible = false


func _process(_delta):
	if hovered:
		emit_signal("seat_hovered")
	
	if filled:
		$Fan.visible = true
		$Hovered.visible = false
		return
	
	# Note: this relies of Hovered being over the Seat in the layering
	if showing_potential_fan:
		$Fan.visible = true
		$Hovered.visible = true
	else:
		$Fan.visible = false
		$Hovered.visible = false


func _on_Seat_mouse_entered():
	hovered = true


func _on_Seat_mouse_exited():
	hovered = false
	emit_signal("seat_unhovered")


func show_potential_fan():
	showing_potential_fan = true


func hide_potential_fan():
	showing_potential_fan = false


func is_prefilled():
	return randf() < PREFILLED_PROBABILITY


func clear():
	$Cleared.visible = true
