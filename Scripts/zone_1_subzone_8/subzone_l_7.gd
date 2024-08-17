extends Area2D

func _on_body_entered(body):
	if body.has_node("is_player"):
		GlobalVars.in_transition = true
		GlobalVars.transition_respawn_point = Vector2(595, 400)
		await get_tree().create_timer(0.5).timeout
		GlobalVars.in_transition = false
		get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_7_boss.tscn")
