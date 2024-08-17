extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_down = $AnimatedSprite2D/ray_cast_down
@onready var ray_cast_down_floorage = $AnimatedSprite2D/ray_cast_down_floorage

@onready var ray_cast_right = $AnimatedSprite2D/ray_cast_right
@onready var ray_cast_left = $AnimatedSprite2D/ray_cast_left

@onready var been_hit = $timers/been_hit
@onready var death_animation = $timers/death_animation

@onready var killzone = $AnimatedSprite2D/killzone

var direction = 1
const SPEED = 35
const VERTSPEED = -65
var rotations = 0
var flip_left = false
var flip_right = false
var expo_gravity = 0.0
var in_animation = false
var can_take_damage = true

var health = 0
var health_decider

var dying = false

func _ready():
	animated_sprite_2d.play("idle_grounded")
	health_decider = randi_range(0, 2)
	if health_decider == 0:
		health = 20
	elif health_decider == 1:
		health = 30
	elif health_decider == 2:
		health = 40
	

func _process(delta):
	position.x += SPEED * delta * direction
	if ray_cast_down_floorage.is_colliding():
		expo_gravity = 0.0
	elif not ray_cast_down.is_colliding():
		position.y += 5 * delta * expo_gravity
		expo_gravity += (1 + delta)
	if ray_cast_right.is_colliding():
		animated_sprite_2d.flip_h = true
		direction = -1
	elif ray_cast_left.is_colliding():
		animated_sprite_2d.flip_h = false
		direction = 1

func damaged():
	if not in_animation and can_take_damage:
		can_take_damage = false
		health = (health - GlobalVars.damage)
		animated_sprite_2d.modulate.r = 0
		in_animation = true
		been_hit.start()
		if health <= 0:
			GlobalVars.something_dying = true
			dying = true
			if killzone != null:
				killzone.queue_free()
			death_animation.start()
			in_animation = true

func _on_been_hit_timeout():
	in_animation = false
	can_take_damage = true
	animated_sprite_2d.modulate.r = 200

func _on_death_animation_timeout():
	queue_free()
