extends Area2D

@onready var player = $"../../Player"
@onready var camera_2d = $"../../Player/Camera2D"


func _on_body_entered(body):
	if body == player:
		GlobalVars.last_cam_limit_bottom = 375
		GlobalVars.last_cam_limit_left = -765
		GlobalVars.change_cam = true
