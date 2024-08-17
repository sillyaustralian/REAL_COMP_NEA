extends Area2D

@onready var player = $"../../Player"
@onready var transition_time_l_1 = $"../transition_time_l_1"


func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		transition_time_l_1.start()

func _on_transition_time_l_1_timeout():
	GlobalVars.in_transition = false
	GlobalVars.transition_respawn_point = Vector2(-740, 25)
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_1.tscn")
