extends Area2D

@onready var camera = $"../../Player/Camera2D"
@onready var player = $"../../Player"


func _on_body_entered(body):
	if body == player:
		camera.limit_right = 985

func _on_body_exited(body):
	if body == player:
		camera.limit_right = 10000000000
