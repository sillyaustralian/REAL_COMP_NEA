extends Area2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var flutter = $flutter

var direction = 0
var speed = 35.0
var vertical = 10.0

func _ready():
	var random_direction = randf()
	if random_direction < 0.45:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func _on_body_entered(body):
	if body:
		collision_shape_2d.queue_free()
		animated_sprite_2d.play("fly_away")
		flutter.play()
		var random_float = randf()
		if random_float > 0.8:
			direction = 1
			animated_sprite_2d.flip_h = false
		else:
			direction = -1
			animated_sprite_2d.flip_h = true

func _process(delta):
	if direction != 0:
		position.x += direction * speed * delta
		position.y += direction * vertical * delta
		speed = 1.05*speed
		vertical = 1.05*vertical
