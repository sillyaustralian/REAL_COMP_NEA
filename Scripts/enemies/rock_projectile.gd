extends Node2D

@onready var projectile = $Projectile

var direction
var speed = 250

func _process(delta):
	position.x += speed * direction * delta
	if direction == 1:
		projectile.flip_h = false
	else:
		projectile.flip_h = true
		
func _on_colliding_body_entered(body):
	if body != null:
		queue_free()

func _on_colliding_area_entered(area):
	if area.is_in_group("enemies"):
		area.damaged()
