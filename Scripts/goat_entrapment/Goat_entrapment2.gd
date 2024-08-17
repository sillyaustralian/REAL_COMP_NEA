extends Sprite2D

var speed = 10
var accel = 4

func _process(delta):
	accel = 2^accel
	if GlobalVars.goat_dead:
		position.x += speed * delta
		position.y += speed * delta
		speed += accel
	if position.x > -20:
		queue_free()
