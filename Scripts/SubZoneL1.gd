extends Area2D
@onready var player = $"../../Player"
@onready var timer = $"../../Timer"

func _on_body_entered(body):
	if body == player:
		GlobalVars.in_transition = true
		GlobalVars.tutorial_over = true
		timer.start()

func _on_timer_timeout():
	GlobalVars.dash_pop_up_allowed = false
	GlobalVars.in_transition = false
	GlobalVars.transition_respawn_point = Vector2(2, 2)
	get_tree().change_scene_to_file("res://Scenes/zone_1_sub_zone_l_1.tscn")
