extends Node2D

@onready var sprite = $sprite
@onready var ray_cast_left = $ray_cast_left
@onready var ray_cast_right = $ray_cast_right

var direction = 1
var speed = 45

var should_move = true

func _ready():
	pass

func _process(delta):
	if should_move:
		if ray_cast_left.is_colliding():
			direction = 1
		elif ray_cast_right.is_colliding():
			direction = -1
		position.x += direction * speed * delta
