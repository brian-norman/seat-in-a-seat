extends Control


export (PackedScene) var Main


func _ready():
	get_tree().set_pause(true)


func _process(_delta):
	if Gamestate.game_over:
		get_tree().set_pause(true)
		if $Main:
			$Main.queue_free()
		$GameOver.visible = true
		$GameOver/Score.text = "SCORE: %d" % Gamestate.score


func _on_RestartButton_button_up():
	Gamestate.score = 0
	Gamestate.game_over = false
	$GameOver.visible = false
	var main = Main.instance()
	add_child(main)
	get_tree().set_pause(false)


func _on_StartButton_pressed():
	$Main.visible = true
	$TitleScreen.visible = false
	$Tutorial.visible = false
	get_tree().set_pause(false)


func _on_TutorialButton_pressed():
	$Tutorial.visible = true
	$TitleScreen.visible = false


func _on_TutorialBackButton_pressed():
	$Tutorial.visible = false
	$TitleScreen.visible = true
