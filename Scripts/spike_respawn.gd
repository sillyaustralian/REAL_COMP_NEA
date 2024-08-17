extends Area2D
@onready var player = $"."

func _on_body_entered(body):
	if body.has_node("is_player"):
		GlobalVars.lives -= 1
		if GlobalVars.lives != 0:
			GlobalVars.fading = true
		if GlobalVars.lives == 0:
			GlobalVars.is_dead = true #kills player 
			print("you're dead")
			Engine.time_scale = 0.75 #slows game down
			body.get_node("CollisionShape2D").queue_free() #stops player colliding with anything
			print("collided")
			await get_tree().create_timer(0.4).timeout
			print("timer complete")
			GlobalVars.is_dead = false #resets player state
			Engine.time_scale = 1 #restores regular game speed
			GlobalVars.lives = 3 #resets livesa
			print("attempting reload")
			get_tree().reload_current_scene() #reloads scene
			print("reloaded")
			GlobalVars.respawn = true
		
