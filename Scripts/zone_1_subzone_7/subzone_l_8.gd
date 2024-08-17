extends Area2D

@onready var player = $"../../Player"

func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		await get_tree().create_timer(0.5).timeout
		GlobalVars.in_transition = false
		get_tree().change_scene_to_file("res://Scenes/zone_1_l_8_to_z_2.tscn")
