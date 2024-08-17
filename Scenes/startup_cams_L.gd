extends Area2D

@onready var camera = $"../../Player/Camera2D"

func _on_body_entered(body):
	if body.has_node("is_player"):
		camera.limit_bottom = 150
		camera.limit_left = -765
		camera.limit_top = 300
