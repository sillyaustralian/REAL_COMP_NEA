extends Area2D

@onready var camera = $"../../Player/Camera2D"
@onready var player = $"../../Player"

func _on_body_entered(body):
	if body == player:
		camera.zoom.x += 5
		camera.zoom.y += 5
		
