extends CharacterBody2D

#imported variables
@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



#movement variables
const SPEED = 175
const JUMP_VELOCITY = -350.0

#Dashing variables
var has_dashed = false #bool value to determine whether the player is in a dashed state or not
var dash_timer = 0.0 #creates a start for the dash timer
const DASH_SPEED = 1000 #sets the dash speed to 1000, cannot be changed
const DASH_DURATION = 0.2 #determines how long the player will dash


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("move_left", "move_right")
	print(Input.get_axis("move_left", "move_right"))
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#flips sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")
	else:
		animated_sprite.play("Jump")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("dash") and not has_dashed:
		has_dashed  = true
		dash_timer = DASH_DURATION
	if is_dashing:
		pass
	
	move_and_slide()
