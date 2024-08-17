extends Area2D

@onready var boss_gate_lock = $"../Boss gate_lock"

func _on_body_entered(body):
	if body.has_node("is_player"):
		print_debug("go down")
		boss_gate_lock.go_down()
