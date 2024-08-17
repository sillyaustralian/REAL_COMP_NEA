extends Node2D

@onready var start_zone = $"."

func _ready():
	GlobalVars.boss_ready = false

func _process(_delta):
	if not GlobalVars.dialogue_playing:
		if Input.is_action_pressed("Kill_game"): #checks if player has quit game every frame
			get_tree().quit() #quits game
		elif Input.is_action_just_pressed("pause"):
			GlobalVars.paused = true


###ADD THE OLD FORGE
###ADD CLOTH
###ADD THE EDGE
