extends Area2D

@onready var player = $"../Player"
@onready var timer = $"../Timer"

func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		timer.start()

func _on_timer_timeout():
	GlobalVars.in_transition = false
	GlobalVars.last_cam_limit_bottom = 150
	GlobalVars.transition_respawn_point = Vector2(-760, 90)
	get_tree().change_scene_to_file("res://Scenes/StartZone.tscn")
	
