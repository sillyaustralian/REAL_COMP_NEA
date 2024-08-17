extends Area2D

@onready var subzone_l_3_transition = $"../subzone_l_3_transition"

func _on_body_entered(body):
	if body.has_node("is_player"):
		GlobalVars.in_transition = true
		subzone_l_3_transition.start()

func _on_subzone_l_3_transition_timeout():
	GlobalVars.in_transition = false
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_3.tscn")
