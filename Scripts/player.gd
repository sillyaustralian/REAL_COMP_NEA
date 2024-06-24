extends CharacterBody2D

#imported variables
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#movement variables
const SPEED = 175
const JUMP_VELOCITY = -350.0
const SMALL_JUMP = -150
var jump_timer = 0.0
var coyote_jump = false
const COYOTE_TIME = 0.2

#Dashing variables
var has_dashed = false #bool value to determine whether the player is in a dashed state or not
var dash_timer = 0.0 #creates a start for the dash timer
const DASH_SPEED = 600  #sets the dash speed, cannot be changed
const DASH_DURATION = 0.2 #determines how long the player will dash
var can_dash = true #determines whether player can dash (based on cooldown)
const COOLDOWN_DURATION = 0.35 #determines cooldown time for dash
var cooldown_timer = 0.0 #creates start for cooldown timer



func _physics_process(delta):
	# Get the input direction
	var direction = Input.get_axis("move_left", "move_right")
	movement_code(direction, delta)
	movement_animations(direction)
	dash(direction, delta)
	move_and_slide() #calls default Godot physics function

func movement_code(direction, delta):
	if GlobalVars.is_dead == false: #checks if player is dead (cannot move if so)
		if direction: #checks if player is holding a direction, moves them
			velocity.x = direction * SPEED #moves player in held direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED) ###default physics
		if not is_on_floor():
			velocity.y += gravity * delta
			
		if Input.is_action_just_pressed("jump") and is_on_floor(): #checks if player is on the floor; jumps if key pressed and condition met
			velocity.y = JUMP_VELOCITY #jumps
		
	else:
		velocity.x = 0
		velocity.y += gravity * delta

func movement_animations(direction):
	if direction > 0 and not GlobalVars.is_dead: #if direction is > 0, player is facing right
		animated_sprite.flip_h = false #default player sprite displayed (facing right)
	elif direction < 0 and not GlobalVars.is_dead: #if direction is < 0, player is facing left
		animated_sprite.flip_h = true #switches sprite to face left
	if not GlobalVars.is_dead: #checks if player is dead or not (animations stop when player dies)
		if has_dashed == false: #checks if player is dashing
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("Idle") #plays idle animation
				else:
					animated_sprite.play("Run") #switches to run animation
			else:
				animated_sprite.play("Jump") #switches to jump animation
		else:
			animated_sprite.play("Dash") #plays dash animation while has_dashed = true
	else:
		animated_sprite.play("Death")

func dash(direction, delta):
	if Input.is_action_just_pressed("dash") and not has_dashed and can_dash and not GlobalVars.is_dead: #checks player state if input pressed; dashes if not dashing currently
		has_dashed  = true #sets player state to be dashing
		dash_timer = DASH_DURATION #starts dash timer
		cooldown_timer = COOLDOWN_DURATION #starts cooldown
		can_dash = false #prevents player from dashing again until cooldown over
	if cooldown_timer > 0: #keeps cooldown timer going
		cooldown_timer -= delta
	else: #restores dash ability
		can_dash = true
		
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
