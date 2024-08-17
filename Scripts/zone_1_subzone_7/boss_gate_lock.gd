extends Node2D

var speed = 0
var accel = 4
var descend = false

func _process(delta):
	if descend and position.y < 383:
		print(position.y)
		accel = 2^accel
		position.y += speed * delta
		speed += accel
	elif position.y >= 383:
		position.y = 384
		descend = false

func go_down():
	speed = 10
	descend = true
