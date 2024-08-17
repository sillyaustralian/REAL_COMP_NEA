extends Area2D

@onready var player = $"../../Player"
@onready var dash_pop_up_animation = $"../Dash_pop_up_animation"

var dont_play = false

func _on_body_entered(body):
	if body == player and dont_play == false and GlobalVars.dash_pop_up_allowed:
		dash_pop_up_animation.play("proper_pop_up")
	elif dont_play == true:
		dash_pop_up_animation.play("how_dash?")

func _on_dash_pop_up_animation_animation_finished():
	GlobalVars.dash_unlocked = true
	dont_play = true
	dash_pop_up_animation.play("how_dash?")
