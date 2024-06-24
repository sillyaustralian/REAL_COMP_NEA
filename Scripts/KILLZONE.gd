extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	GlobalVars.is_dead = true
	print("You died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()

func _on_timer_timeout():
	GlobalVars.is_dead = false
	Engine.time_scale = 1
	GlobalVars.lives -= 1
	get_tree().reload_current_scene()
