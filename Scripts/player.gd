extends CharacterBody2D

#imported variables
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var invincibility = $invincibility
var invincible_timer = true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#movement variables
const SPEED = 195
const JUMP_VELOCITY = -375.0
const SMALL_JUMP = -150
var jump_timer = 0.0
var small_jumps = 1
var big_jumps = 1

#Dashing variables
var has_dashed = false #bool value to determine whether the player is in a dashed state or not
var dash_timer = 0.0 #creates a start for the dash timer
const DASH_SPEED = SPEED * 3  #sets the dash speed, cannot be changed
const DASH_DURATION = 0.15 #determines how long the player will dash
var can_dash = true #determines whether player can dash (based on cooldown)
const COOLDOWN_DURATION = 0.45 #determines cooldown time for dash
var cooldown_timer = 0.0 #creates start for cooldown timer

#healing
var is_healing = false
@onready var heal_cooldown = $heal_cooldown

#WallJump
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var wall_jump_length = $wall_jump_length

var launched_off_wall = false

#crouching
var is_crouching = false

#combat - see GlobalVars
#begins wit 3 health, 10 dmg
var attack_hitbox = preload("res://Scenes/slash_hitbox.tscn")
var attack_direction = Vector2()
var can_attack = true
@onready var slash_cooldown = $slash_cooldown
@onready var hitbox_removed = $hitbox_removed
@onready var slash_attack_animation = $Slash_attack

#SFX
@onready var dash_sfx = $SFX/Dash_sfx
@onready var attack_sfx = $SFX/Attack_sfx

var flipped = false

var throwback = 25

#particles
@onready var walk_particles = $CPUParticles2D

func _ready():
	GlobalVars.last_cam_limit_bottom = 150
	animated_sprite.flip_h = true
	GlobalVars.spikes = false
	position = GlobalVars.transition_respawn_point

func _physics_process(delta):
	if not GlobalVars.dialogue_playing and not GlobalVars.paused:
		if not GlobalVars.in_transition: #ensures player cannot move during transition screens
			if is_on_floor(): #resets jump count after landing
				big_jumps = 1
				small_jumps = 1
			var direction = Input.get_axis("move_left", "move_right")
			if direction == -1:
				walk_particles.scale.x = -1
			else:
				walk_particles.scale.x = 1
			if is_crouching != true:
				movement_animations(direction)
				wall_jump(delta, direction)
			#if GlobalVars.invincibility != true:
			movement_code(direction, delta)
			#elif GlobalVars.invincibility and has_dashed:
				#movement_code(direction, delta)
			if GlobalVars.dash_unlocked or not GlobalVars.dash_unlocked:
				dash(direction, delta)
			crouch(direction)
		else:
			velocity = Vector2(0, 0)
	elif GlobalVars.dialogue_playing:
		walk_particles.emitting = false
		velocity.x = 0
		velocity.y += 50
		has_dashed = false
		animated_sprite.play("Idle")
	
	move_and_slide() #calls default Godot physics function

func _process(_delta):
	transition_spawn_points()
	if GlobalVars.player_ready_for_dialogue:
		velocity.x = 0
	if GlobalVars.respawn_needed:
		set_respawn()
		print("SETTING RESPAWN")
		GlobalVars.respawn_needed = false
	if GlobalVars.respawn == true:
		respawn()
		GlobalVars.respawn = false
	if not GlobalVars.invincibility and throwback != 25:
		throwback = 25

func movement_code(direction, delta):
	if GlobalVars.invincibility:
		velocity = Vector2(450 * int(animated_sprite.flip_h), -gravity * delta * throwback)
		throwback /= 1.5
	if Input.is_action_just_released("jump") and not is_on_wall() and small_jumps != 0 and velocity.y < 0:
		velocity.y = velocity.y/5
	if launched_off_wall:
		direction = -direction
	if GlobalVars.is_dead == false: #checks if player is dead (cannot move if so)
		if direction and not launched_off_wall: #checks if player is holding a direction, moves them
			velocity.x = direction * SPEED #moves player in held direction
		elif not launched_off_wall and not direction:
			velocity.x = move_toward(velocity.x, 0, SPEED) ###default physics
		if not is_on_floor():
			velocity.y += gravity * delta
		if not is_on_floor() and small_jumps == 0:
			if Input.is_action_pressed("down") and not is_crouching:
				velocity.y += 20
		else:
			if Input.is_action_just_pressed("jump") and is_on_floor() and big_jumps != 0: #checks if player is on the floor; jumps if key pressed and condition met
				if not is_crouching:
					velocity.y += JUMP_VELOCITY #jumps
					big_jumps -= 1 #reduces possible jump count
				else:
					velocity.y += JUMP_VELOCITY #jumps
					big_jumps -= 1 #reduces possible jump count
					velocity.y -= 35
			if Input.is_action_just_pressed("jump") and not is_on_floor() and small_jumps > 0: #double jump
				velocity.y = 0
				velocity.y += (JUMP_VELOCITY+75) #jumps midair
				small_jumps -= 1 #no more jumps until floor hit
			if Input.is_action_pressed("down") and not is_on_floor() and not is_crouching:
				velocity.y += 35
	else: 
		velocity.x = 0
		velocity.y += gravity * delta

func movement_animations(direction):
	if is_on_wall() and ray_cast_left.is_colliding():
		animated_sprite.flip_h = true
	elif is_on_wall() and ray_cast_right.is_colliding():
		animated_sprite.flip_h = false
	if GlobalVars.invincibility == true and invincible_timer:
		invincibility.start()
		invincible_timer = false
	if not invincible_timer:
		animated_sprite.play("taken_damage")
	elif GlobalVars.hit_spikes == true:
		animated_sprite.play("taken_damage")
	else:
		if is_healing:
			animated_sprite.play("Healing")
			return
		if direction > 0 and not GlobalVars.is_dead: #if direction is > 0, player is facing right
			animated_sprite.flip_h = false #default player sprite displayed (facing right)
		elif direction < 0 and not GlobalVars.is_dead: #if direction is < 0, player is facing left
			animated_sprite.flip_h = true #switches sprite to face left
		if not GlobalVars.is_dead: #checks if player is dead or not (animations stop when player dies)
			if has_dashed == false: #checks if player is dashing
				if not is_on_wall():
					if is_on_floor():
						if direction == 0 and not Input.is_action_pressed("up"):
							animated_sprite.play("Idle") #plays idle animation
							walk_particles.emitting = false
						elif Input.is_action_pressed("up") and velocity.x == 0 and velocity.y == 0:
							animated_sprite.play("looking_up")
							walk_particles.emitting = false
						else:
							animated_sprite.play("Run") #switches to run animation
							walk_particles.emitting = true
					elif not is_on_floor() and (small_jumps == 0 or big_jumps == 0) and velocity.y > 0:
						animated_sprite.play("Falling")
						walk_particles.emitting = false
					elif not is_on_floor() and velocity.y < 0 and small_jumps == 1:
						animated_sprite.play("Jump") #switches to jump animation
						walk_particles.emitting = false
					elif small_jumps == 0 and big_jumps == 0:
						animated_sprite.play("Small_jump")
						walk_particles.emitting = false
					else:
						animated_sprite.play("Falling")
						walk_particles.emitting = false
				else:
					if not is_on_floor():
						animated_sprite.play("Wall_slide")
					else:
						animated_sprite.play("Idle")
			else:
				animated_sprite.play("Dash") #plays dash animation while has_dashed = true
		else:
			animated_sprite.play("Death")

func dash(direction, delta):
	if GlobalVars.invincibility:
		dash_timer = 0
	if Input.is_action_just_pressed("dash") and not has_dashed and can_dash and not GlobalVars.is_dead and not is_on_wall(): #checks player state if input pressed; dashes if not dashing currently
		has_dashed  = true #sets player state to be dashing
		dash_timer = DASH_DURATION #starts dash timer
		cooldown_timer = COOLDOWN_DURATION #starts cooldown
		can_dash = false #prevents player from dashing again until cooldown over
		dash_sfx.play() #plays dash sound
	if cooldown_timer > 0: #keeps cooldown timer going
		cooldown_timer -= delta
	else: #restores dash ability
		can_dash = true
	if GlobalVars.player_ready_for_dialogue:
		dash_timer -= dash_timer
		velocity.x = 0
	if has_dashed:
		dash_timer -= delta #reduces timer by set delta (eventually stops dash)
		if dash_timer <= 0: #checks when timer is finished
			has_dashed = false #sets player state to not dashing
	if has_dashed and direction != 0: #checks if player is already moving in a direction
		velocity.x = direction * DASH_SPEED #dashes in direction faced
		velocity.y = 0 #freezes players Y position, makes them fall after dash
	elif has_dashed and direction == 0: #checks if player is stationary
		velocity.y = 0 #freezes players Y position, makes them fall after dash
		if animated_sprite.flip_h == false: #checks which direction player faces even if no button pressed
			velocity.x = DASH_SPEED #dashes
		elif animated_sprite.flip_h == true:
			velocity.x = -DASH_SPEED #dashes
	if GlobalVars.is_dead: #stops dash if dead
		velocity.x = 0
		velocity.y += gravity * delta

func wall_jump(delta, direction):
	if is_on_wall() and not is_on_floor():
		if small_jumps < 1:
			small_jumps += 1
		velocity.y +=  gravity * delta * -0.25
		if Input.is_action_just_pressed("down"):
			if direction == 0 and animated_sprite.flip_h == true:
				position.x += 2
			elif direction == 0 and animated_sprite.flip_h != true:
				position.x -= 2
			else:
				position.x += 1 * direction
		if Input.is_action_just_pressed("jump") and not is_on_floor() and small_jumps > 0: #double jump
			if direction == 0:
				if ray_cast_right.is_colliding():
					direction = -1
					animated_sprite.flip_h = false
				elif ray_cast_left.is_colliding():
					direction = 1
					animated_sprite.flip_h = true
				velocity.x += 1.5 * SPEED * direction
				launched_off_wall = true
				wall_jump_length.start()
				velocity.y = 0
				velocity.y += (JUMP_VELOCITY+75) #jumps midair
				small_jumps -= 1
			else:
				if animated_sprite.flip_h and direction == -1:
					direction = 1
					animated_sprite.flip_h = false
				else:
					direction = -1
					animated_sprite.flip_h = true
				velocity.x += 1.5 * SPEED * direction
				launched_off_wall = true
				wall_jump_length.start()
				velocity.y = 0
				velocity.y += (JUMP_VELOCITY+75) #jumps midair
				small_jumps -= 1

func _on_wall_jump_length_timeout():
	launched_off_wall = false

func crouch(direction):
	if Input.is_action_pressed("down") and is_on_floor() and direction == 0:
		is_crouching = true
		animated_sprite.play("Crouch_Idle")
	else:
		is_crouching = false

func respawn():
	has_dashed = false
	velocity = Vector2(0,0)
	position = GlobalVars.respawn_point
	#camera.limit_bottom = GlobalVars.last_cam_limit_bottom

func set_respawn():
	GlobalVars.respawn_point = position

func _input(event):
	if not GlobalVars.dialogue_playing:
		if event.is_action_pressed("slash_attack") and GlobalVars.has_sword and can_attack and not (is_on_wall() and not is_on_floor()) and not GlobalVars.is_dead and not Input.is_action_pressed("down"):
			attack_sfx.play()
			var direction = Input.get_axis("move_left", "move_right")
			can_attack = false
			GlobalVars.is_attacking = true
			GlobalVars.hitbox = attack_hitbox.instantiate()
			print("slash registered")
			if animated_sprite.flip_h:
				slash_attack_animation.flip_h = true
				slash_attack_animation.position.x = -9
			else:
				slash_attack_animation.flip_h = false
				slash_attack_animation.position.x = 9
			if Input.is_action_pressed("up"):
				attack_direction = Vector2(0, -1)
			else:
				if direction == 1 or not animated_sprite.flip_h:
					attack_direction = Vector2(1, 0)
				elif direction == -1 or animated_sprite.flip_h:
					attack_direction = Vector2(-1, 0)
			slash_attack_animation.play('slash_attack')
			if not is_on_floor():
				if self.velocity.y < 0:
					GlobalVars.hitbox.position = global_position + attack_direction * 40
					print("extras")
			print("direction registered")
			GlobalVars.hitbox.position = global_position + attack_direction * 20
			get_tree().root.add_child(GlobalVars.hitbox)
			slash_cooldown.start()
			hitbox_removed.start()
			
		elif event.is_action_pressed("heal") and GlobalVars.lives < 3 and GlobalVars.heal_potion_count > 0:
			GlobalVars.fully_healed = false 
			is_healing = true
			GlobalVars.healing = true
			heal_cooldown.start() 
		elif event.is_action_released("heal"):
			is_healing = false
			GlobalVars.healing = false
			heal_cooldown.stop()

func _on_slash_cooldown_timeout():
	can_attack = true
	GlobalVars.is_attacking = false
	slash_cooldown.stop()

func _on_hitbox_removed_timeout():
	if GlobalVars.hitbox != null:
		GlobalVars.hitbox.queue_free()
		print("no more hitbox!")

func _on_heal_cooldown_timeout():
	GlobalVars.fully_healed = true
	is_healing = false
	GlobalVars.heal_potion_count -= 1 
	GlobalVars.healing = false  
	GlobalVars.lives +=1
	heal_cooldown.stop()

func _on_invincibility_timeout():
	GlobalVars.invincibility = false
	invincible_timer = true

func transition_spawn_points():
	if GlobalVars.zone_1_main_L:
		position.x = -750
		position.y = 85
		GlobalVars.zone_1_main_L = false
	if GlobalVars.z1_subzone_2_into_1:
		position.x = -750
		position.y = 25
		camera.limit_left = -765
		GlobalVars.z1_subzone_2_into_1 = false
