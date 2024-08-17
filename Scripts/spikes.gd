extends Node2D
@onready var player = $"."

func _on_killzone_body_entered(body):
	if body:
		GlobalVars.spikes = true
