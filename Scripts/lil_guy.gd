extends Node2D

@onready var killzone_despawn = $killzone_despawn
@onready var death_animation = $death_animation
@onready var killzone = $killzone
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var been_hit = $been_hit
@onready var player_attacked = $"Player_attacked?"

var can_take_damage = true
var health = 100
var dying = false
var in_animation = false
var direction = 0
var speed = 30

func _ready():
	if randf() > 0.5:
		direction = -1
	else:
		direction = 1

func _process(delta):
	if not in_animation and not dying:
		animated_sprite_2d.play("idle_walk")
		speed = 45
		if ray_cast_right.is_colliding():
				direction = -1
				animated_sprite_2d.flip_h = true
		elif ray_cast_left.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = false
		position.x += direction * speed * delta

func damaged():
	if can_take_damage:
		can_take_damage = false
		health -= GlobalVars.damage
		animated_sprite_2d.modulate.r = 255
		been_hit.start()
		if health <= 0:
			player_attacked.queue_free()
			in_animation = true
			GlobalVars.something_dying = true
			dying = true
			killzone_despawn.start()
			death_animation.start()
			animated_sprite_2d.play("death")

func _on_killzone_despawn_timeout():
	if killzone != null:
		killzone.queue_free()

func _on_been_hit_timeout():
	in_animation = false
	can_take_damage = true
	animated_sprite_2d.modulate.r = 0

func _on_death_animation_timeout():
	queue_free()
