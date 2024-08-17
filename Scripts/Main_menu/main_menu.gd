extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/StartZone.tscn")

func _on_texture_button_pressed():
	get_tree().quit()
