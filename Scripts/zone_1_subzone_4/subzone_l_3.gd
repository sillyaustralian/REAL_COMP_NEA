extends Area2D

@onready var player = $"../../Player"
@onready var transition_time_l_3 = $"../transition_time_l_3"

func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		transition_time_l_3.start()

func _on_transition_time_l_3_timeout():
	GlobalVars.in_transition = false
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_3.tscn")
