extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_forward = $RayCastForward
@onready var ray_cast_backward = $RayCastBackward
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var been_hit = $been_hit
@onready var death_animation = $death_animation
@onready var damage_area = $Damage_area

var projectile = preload("res://Scenes/enemy_projectiles/rock_projectile.tscn")

const SPEED = 35
var direction = 1
var health = 50

var player = CharacterBody2D

var can_take_damage = true
var in_animation = false
var dying = false

func _ready():
	if randf() > 0.5:
		direction = -1

func _process(delta):
	if not in_animation and not dying: 
		animated_sprite_2d.play("idle")
		position.x += direction * SPEED * delta #generic movement code
		if ray_cast_right.is_colliding() or not ray_cast_forward.is_colliding():
			direction = -1
			animated_sprite_2d.flip_h = true
		elif ray_cast_left.is_colliding() or not ray_cast_backward.is_colliding():
			direction = 1
			animated_sprite_2d.flip_h = false

func launch_rock(): #is it even a rock?
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
		var projectile_local = projectile.instantiate()
		projectile_local.position = global_position
		projectile_local.direction = direction
		get_tree().root.call_deferred("add_child", projectile_local)

func damaged():
	if not in_animation and can_take_damage:
		launch_rock()
		can_take_damage = false
		health -= GlobalVars.damage
		var pos = player.global_position - global_position
		if pos.x >= 0:
			if animated_sprite_2d.flip_h == false:
				position.x -= 15
			else:
				position.x -= 0
		elif pos.x <= 0:
			if animated_sprite_2d.flip_h == false:
				position.x += 0
			else:
				position.x += 15
		animated_sprite_2d.play("Been Hit")
		in_animation = true
		been_hit.start()
		if health <= 0:
			damage_area.queue_free() #TODO: explain that bug was caused due to repeated hits that led to this fix
			GlobalVars.something_dying = true
			dying = true
			death_animation.start()
			in_animation = true

func _on_been_hit_timeout():
	in_animation = false
	can_take_damage = true

func _on_death_animation_timeout():
	queue_free()

func _on_player_detector_body_entered(body):
	if body.has_node("is_player"):
		player = body
