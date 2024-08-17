extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ray_cast_left = $Ray_cast_left
@onready var ray_cast_right = $Ray_cast_right
@onready var killzone = $killzone

var DWARVEN_BRUTE_ATTACK_2 = preload("res://Scenes/Dwarven brute/dwarven_brute_attack_2.tscn")

var health = 170 #150-300

var speed = 0
var direction = 0

var horizontal_charge = false
var vertical_charge = false

var collapsed = false
var jumping = false
var in_range = false
var attack_object

var pos

#attack_cooldown
const COOLDOWN_TIMER = 0.2
var cooldown_time = 30
var can_attack = true

#attack 1
var spinning_sideways = false

#attack 2
var attack_2
var rand_spawn = 182
var attack_two_allowed = true
var throwing_hat = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var downed = false
var boss_dead = false

func _ready():
	animated_sprite_2d.play("idle")
	speed = 0

func _process(delta):
	if GlobalVars.boss_ready and not downed and not boss_dead:
		animations()
		velocity.x = direction * speed
		if attack_object:
			pos = attack_object.global_position - global_position
		if can_attack and in_range and not collapsed:
			var attack_decider = randi_range(0, 14)
			print_debug(attack_decider)
			if attack_decider > 9:
				if attack_two_allowed:
					attack_two()
					can_attack = false
			elif attack_decider > 5 and attack_decider < 10:
				attack_one()
				can_attack = false
			else:
				attack_three()
				can_attack = false
		if not can_attack and not throwing_hat:
			if cooldown_time > 0:
				cooldown_time -= COOLDOWN_TIMER
			else:
				can_attack = true
				cooldown_time = 50
		else:
			cooldown_time = 50
		if speed > 0 and collapsed:
			speed -= (speed / 1.25) * delta
			if speed < 50 and speed != 0:
				speed = 0
				await get_tree().create_timer(0.25).timeout
				animated_sprite_2d.flip_h = false
				collapsed = false
			if can_attack:
				speed = 0
				animated_sprite_2d.flip_h = false
				collapsed = false
		if ray_cast_left.is_colliding() and spinning_sideways:
			collapsed = true
			spinning_sideways = false
			direction = 1
			speed = 130
			if not is_on_floor():
				velocity.y += gravity * delta
		elif ray_cast_right.is_colliding() and spinning_sideways:
			collapsed = true
			spinning_sideways = false
			direction = -1
			speed = 130
			if not is_on_floor():
				velocity.y += gravity * delta
		move_and_slide()
	elif downed and GlobalVars.boss_ready:
		if not is_on_floor():
			velocity.y += gravity * 0.2
		animated_sprite_2d.play("collapsed")

func animations():
	if spinning_sideways:
		animated_sprite_2d.play("spinning_sideways")
	elif collapsed:
		animated_sprite_2d.play("collapsed")
	elif jumping:
		animated_sprite_2d.play("jump")
	elif horizontal_charge:
		animated_sprite_2d.play("horizontal_charge")
	elif vertical_charge:
		animated_sprite_2d.play("vertical_charge")
	elif throwing_hat:
		animated_sprite_2d.play("hat_time")
	else:
		animated_sprite_2d.play("idle")

func jump():
	pass #Jumps around a tad before attacking; just like false knight

func attack_one():
	print_debug("ATTACK ONE")
	horizontal_charge = true
	if pos.x < 0:
		animated_sprite_2d.flip_h = false
		direction = -1
	else:
		animated_sprite_2d.flip_h = true
		direction = 1
	await get_tree().create_timer(0.5).timeout
	horizontal_charge = false
	spinning_sideways = true
	speed = 350

func attack_two():
	can_attack = false
	throwing_hat = true
	attack_two_allowed = false
	animated_sprite_2d.position.y -= 8
	attack_2 = DWARVEN_BRUTE_ATTACK_2.instantiate()
	attack_2.position = Vector2(150, 436)
	get_tree().root.add_child.call_deferred(attack_2)
	#await get_tree().create_timer(0.1).timeout
	for i in range(13):
		attack_2 = DWARVEN_BRUTE_ATTACK_2.instantiate()
		attack_2.position = Vector2(rand_spawn, 436)
		get_tree().root.add_child.call_deferred(attack_2)
		rand_spawn += 32
		#await get_tree().create_timer(0.15).timeout
	await get_tree().create_timer(1).timeout
	can_attack = true
	animated_sprite_2d.position.y += 8
	throwing_hat = false
	await get_tree().create_timer(5).timeout
	rand_spawn = 166
	attack_two_allowed = true

func attack_three():
	vertical_charge = true
	await get_tree().create_timer(0.2).timeout
	vertical_charge = false
	jumping = true
	velocity.y -= 500
	await get_tree().create_timer(0.45).timeout
	velocity.y += 1500
	position.x = (attack_object.global_position).x
	await  get_tree().create_timer(0.5).timeout
	jumping = false

func _on_detection_area_body_entered(body):
	if body.has_node("is_player"):
		print_debug("BODY ENTERED")
		attack_object = body
		in_range = true

func _on_detection_area_body_exited(body):
	if body.has_node("is_player"):
		print_debug("BODY EXITED")
		in_range = false

func damaged():
	health -= GlobalVars.damage
	animated_sprite_2d.modulate = Color(255, 255, 255, 255)
	if health == 100:
		downed = true
		await get_tree().create_timer(0.2).timeout
		animated_sprite_2d.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(2).timeout
		can_attack = false
		downed = false
	elif health == 50:
		downed = true
		await get_tree().create_timer(0.2).timeout
		animated_sprite_2d.modulate = Color(1, 1, 1, 1)
		await get_tree().create_timer(2).timeout
		can_attack = false
		downed = false
	elif health == 0:
		boss_dead = true
		killzone.queue_free()
		animated_sprite_2d.play("defeated")
		GlobalVars.player_ready_for_dialogue = true
		GlobalVars.next_line_of_dialogue = true
		GlobalVars.dialogue_num = 18
		GlobalVars.who_talking = "BRUTE"
	await get_tree().create_timer(0.2).timeout
	animated_sprite_2d.modulate = Color(1, 1, 1, 1)
