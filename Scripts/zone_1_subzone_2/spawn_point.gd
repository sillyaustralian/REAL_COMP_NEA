extends Area2D

func _on_body_entered(body):
	if body.has_node("is_player"):
		GlobalVars.respawn_needed = true
