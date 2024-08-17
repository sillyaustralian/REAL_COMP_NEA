extends Area2D

func _on_body_entered(body):
	if body.has_node("CollisionShape2D") and body.has_node("is_player"): #ensures the body must have a collider, to prevent null errors
		if GlobalVars.lives != 0 and not GlobalVars.invincibility:
			GlobalVars.lives -= 1
			GlobalVars.invincibility = true
			if GlobalVars.spikes == true:
				GlobalVars.hit_spikes = true
				get_tree().reload_current_scene()
		if GlobalVars.lives == 0:
			GlobalVars.is_dead = true #kills player 
			print("you're dead")
			Engine.time_scale = 0.75 #slows game down
			body.get_node("CollisionShape2D").queue_free() #stops player colliding with anything
			print("collided")
			print("timer started")
			await get_tree().create_timer(0.4).timeout
			print("timer over")
			GlobalVars.is_dead = false #resets player state
			Engine.time_scale = 1 #restores regular game speed
			GlobalVars.lives = 3 #resets livesa
			print("attempting reload")
			get_tree().reload_current_scene() #reloads scene
			print("reloaded")
			GlobalVars.respawn = true
