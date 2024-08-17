extends Area2D

func _on_body_entered(body):
	if body.has_node("is_player"):
		if GlobalVars.first_time:
			print_debug("first time")
			GlobalVars.player_ready_for_dialogue = true
			GlobalVars.next_line_of_dialogue = true
			GlobalVars.dialogue_num = 1
			GlobalVars.who_talking = "BRUTE"
			print_debug(GlobalVars.who_talking)
			queue_free()
			GlobalVars.first_time = false
			GlobalVars.second_time = true
		elif GlobalVars.second_time:
			print_debug("second time")
			GlobalVars.player_ready_for_dialogue = true
			GlobalVars.next_line_of_dialogue = true
			GlobalVars.dialogue_num = 8
			GlobalVars.who_talking = "BRUTE"
			queue_free()
			GlobalVars.second_time = false
			GlobalVars.third_time = true
		elif GlobalVars.third_time:
			print_debug("third time")
			GlobalVars.player_ready_for_dialogue = true
			GlobalVars.next_line_of_dialogue = true
			GlobalVars.dialogue_num = 13
			GlobalVars.who_talking = "BRUTE"
			queue_free()
			GlobalVars.third_time = false
		else:
			GlobalVars.boss_ready = true
