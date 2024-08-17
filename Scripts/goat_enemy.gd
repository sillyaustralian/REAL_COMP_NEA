extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_forward = $RayCastForward
@onready var ray_cast_backward = $RayCastBackward
@onready var timer = $Timer
@onready var death_animation = $death_animation
@onready var been_hit = $been_hit
@onready var killzone = $killzone
@onready var ouch = $sounds/ouch

var can_take_damage = true
var player_exited = true
var angry = false
var dying = false

var speed = 45
var direction = 1
var health = 30

var in_animation = false

var player
func ready():
	for i in range(10):
		animated_sprite_2d.play("Rested Walk")

func _process(delta):
	if dying:
		animated_sprite_2d.play("death")
	if not in_animation and not dying:
		if not angry and player_exited:
			animated_sprite_2d.play("Rested Walk")
			speed = 45
		elif angry and not player_exited and health <= 10:
			animated_sprite_2d.play("really annoyed")
			speed = 250
		else:
			animated_sprite_2d.play("Evil Walk")
			speed = 175
		position.x += direction * speed * delta
		if ray_cast_right.is_colliding() or not ray_cast_forward.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = true
		elif ray_cast_left.is_colliding() or not ray_cast_backward.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = false

func _on_player_detection_body_entered(body):
	if body.has_node("is_player"):
		player = body
		if not angry:
			direction_check()
			player_exited = false
			in_animation = true
			if not player_exited:
				pass
			animated_sprite_2d.play("Evil Possession")
			timer.start()

func _on_timer_timeout():
	in_animation = false
	angry = true

func _on_player_left_body_exited(body):
	if body == player:
		player_exited = true
		timer.stop()
		in_animation = false
		angry = false

func direction_check():
	if player != null:
		var pos = player.global_position - global_position
		if pos.x >= 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		if direction == int(animated_sprite_2d.flip_h):
			direction = -direction
		elif direction == -1 and not animated_sprite_2d.flip_h:
			direction = -direction

func damaged():
	if not in_animation and can_take_damage and not GlobalVars.fading:
		can_take_damage = false
		health -= GlobalVars.damage
		if player != null:
			var pos = player.global_position - global_position
			if pos.x >= 0:
				if animated_sprite_2d.flip_h == false:
					position.x -= 25
				else:
					position.x += 25
			elif pos.x <= 0:
				if animated_sprite_2d.flip_h == false:
					position.x += 0
				else:
					position.x += 25
		animated_sprite_2d.play("Been Hit")
		in_animation = true
		been_hit.start()
		if health <= 0:
			GlobalVars.something_dying = true
			dying = true
			if killzone != null:
				killzone.queue_free()
			death_animation.start()
			in_animation = true
		ouch.play()
	if GlobalVars.fading:
		angry = false

func _on_death_animation_timeout():
	GlobalVars.goat_dead = true
	queue_free()

func _on_been_hit_timeout():
	in_animation = false
	can_take_damage = true
