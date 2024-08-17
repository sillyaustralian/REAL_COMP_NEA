extends Area2D

@onready var sword_sprite = $Sword_sprite
@onready var player = $"../../Player"
@onready var sign_changed = $"../../Sign"


var activation_allowed = true
var loop = 0

func _ready():
	sword_sprite.play("still_sword")

func _on_body_entered(body):
	if body == player and activation_allowed:
		sword_sprite.position.y -= 8
		sword_sprite.play("swordhover")
		activation_allowed = false
		sign_changed.frame += 1
		
func _on_sword_sprite_animation_finished():
	if loop == 0:
		sword_sprite.play("sword_bequeathment")
		loop += 1
	else:
		sword_sprite.play("sword_waiting")
