extends Area2D
@onready var player = $"../../../Player"

func _on_body_entered(body):
	if body.has_node("is_player") and not GlobalVars.tutorial_over:
		player.velocity.y += 100
		await player.is_on_floor()
		GlobalVars.player_ready_for_dialogue = true
		GlobalVars.next_line_of_dialogue = true
		GlobalVars.dialogue_num = 12
		GlobalVars.who_talking = "GERALD"
		queue_free()
