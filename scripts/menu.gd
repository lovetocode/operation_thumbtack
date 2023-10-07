extends Control

func _ready():
	$VBoxContainer/Start.grab_focus()
	$AudioStreamPlayer.play()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level_01.tscn")

func _on_quit_pressed():
	get_tree().quit()
