extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body):
	print("You died!")
	Engine.time_scale = 0.5
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
