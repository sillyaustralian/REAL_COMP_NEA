extends Area2D

@onready var player = $"../../Player"
@onready var transition_time_l_6 = $"../transition_time_l_6"


func _on_body_entered(body):
	if body.has_node("is_player"):
		GlobalVars.in_transition = true
		transition_time_l_6.start()

func _on_transition_time_l_6_timeout():
	GlobalVars.in_transition = false
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_6.tscn")
