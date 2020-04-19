extends CanvasLayer


# Signals
signal start_game


# Constants
const GAME_OVER_MSG = "Game Over"
const GAME_TITLE = "Dodge the\nCreeps!"


# ScoreLabel handling
func update_score(score: int):
	$ScoreLabel.text = str(score)


# MessageLabel handling
func show_message(text: String):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message(GAME_OVER_MSG)

	yield($MessageTimer, "timeout")

	$MessageLabel.text = GAME_TITLE
	$MessageLabel.show()

	yield(get_tree().create_timer(1), "timeout")

	$StartButton.show()


# Signal handling
func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
