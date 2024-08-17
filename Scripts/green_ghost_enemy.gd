extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var been_hit = $been_hit
@onready var death_animation = $death_animation
@onready var killzone = $killzone
@onready var player_attacked = $"player_attacked?"

var direction_faced = 0
var can_take_damage = true
var speed = 75
var accelaration = 10
var target = false
var attack_target = CharacterBody2D
var dying = false
var health = 30
var in_animation = false

func _process(_delta):
	if not in_animation and not dying:
		animated_sprite_2d.play("ghost")
	
func _physics_process(delta):
	var direction = Vector2()
	if target and not dying:
		var pos = attack_target.position - global_position
		if pos.x >= 0:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
		navigation_agent_2d.target_position = attack_target.position
		
		direction = navigation_agent_2d.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accelaration * delta)
		
		move_and_slide()

func _on_player_detection_body_entered(body):
	if body.has_node("is_player"):
		target = true
		attack_target = body

func damaged():
	if can_take_damage and not in_animation:
		print("taken damage L")
		can_take_damage = false
		health -= GlobalVars.damage
		var pos = attack_target.global_position - global_position
		if pos.x >= 0:
			if animated_sprite_2d.flip_h == false:
				position.x -= 35
			else:
				position.x -= 0
		elif pos.x <= 0:
			if animated_sprite_2d.flip_h == false:
				position.x += 0
			else:
				position.x += 35
		animated_sprite_2d.play("ouch")
		in_animation = true
		been_hit.start()
		if health <= 0:
			player_attacked.queue_free()
			in_animation = true
			animated_sprite_2d.play("death")
			GlobalVars.something_dying = true
			dying = true
			if killzone != null:
				killzone.queue_free()
			death_animation.start()

func _on_been_hit_timeout():
	in_animation = false
	can_take_damage = true

func _on_death_animation_timeout():
	queue_free()
