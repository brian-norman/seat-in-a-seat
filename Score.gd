extends Label

var score_text = "Score: %d"

func _process(_delta):
	text = score_text % Gamestate.score
