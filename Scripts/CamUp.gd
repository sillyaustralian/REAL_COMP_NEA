extends Area2D

@onready var camera = $"../../Player/Camera2D"
@onready var player = $"../../Player"

func _on_body_entered(body):
	if body.name == "Player": #checks if player contacted collision zone
		camera.limit_bottom = 100 #raises camera limit
		GlobalVars.last_cam_limit_bottom = 100
