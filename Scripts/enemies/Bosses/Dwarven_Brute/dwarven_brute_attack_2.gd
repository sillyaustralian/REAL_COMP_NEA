extends Node2D

@onready var warning_hats = $"Warning hats"
@onready var actual_hats = $"Actual hats"

var fly = false
var accel = 0.5

func _ready():
	warning_hats.visible = false
	actual_hats.visible = false
	warn()

func _process(delta):
	if fly:
		position.y -= accel
		accel += 15 * delta

func warn():
	warning_hats.visible = true
	warning_hats.play("Warning")
	await get_tree().create_timer(1).timeout
	attack()

func attack():
	warning_hats.visible = false
	actual_hats.visible = true
	actual_hats.play("spinning_hats")
	fly = true
