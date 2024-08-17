extends Area2D

@onready var player = $"../../Player"
@onready var transition_l_2 = $"../transition_l_2"

func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		transition_l_2.start()

func _on_transition_l_2_timeout():
	GlobalVars.in_transition = false
	GlobalVars.transition_respawn_point = Vector2(-15, -15)
	GlobalVars.last_cam_limit_bottom = 600
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_2.tscn")
