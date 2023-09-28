extends Control

func set_score(value):
	$Panel/Score.text = "Score: " + str(value)

func set_high_score(value):
	$Panel/HighScore.text = "High-Score: " + str(value)

func _on_retry_pressed():
	get_tree().reload_current_scene()
