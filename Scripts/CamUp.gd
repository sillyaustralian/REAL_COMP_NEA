extends Area2D

@onready var camera = $"../../Player/Camera2D"
@onready var player = $"../../Player"

func _on_body_entered(body):
	if body.name == "Player":
		print("CamUP")
		camera.limit_bottom = 100
		camera.limit_right = camera.limit_right
		camera.limit_left = camera.limit_left
		camera.limit_top = camera.limit_top
