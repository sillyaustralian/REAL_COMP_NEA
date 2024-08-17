extends Node2D

@onready var pellet = $pellet

var speed = 250

func _process(delta):
	position.y += speed * delta

func _on_colliding_body_entered(body):
	if body != null:
		queue_free()
