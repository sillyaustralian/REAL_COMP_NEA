extends Area2D
@onready var player = $"../../../Player"

func _on_body_entered(body):
	if body == player:
		GlobalVars.player_ready_for_dialogue = true
		GlobalVars.next_line_of_dialogue = true
		GlobalVars.dialogue_num = 12
