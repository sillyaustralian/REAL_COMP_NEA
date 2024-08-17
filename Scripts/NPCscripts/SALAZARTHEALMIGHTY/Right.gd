extends Area2D

@onready var animated_sprite_2d = $"../AnimatedSprite2D"

func _on_body_entered(_body):
	animated_sprite_2d.flip_h = true

func _on_body_exited(_body):
	animated_sprite_2d.flip_h = true
