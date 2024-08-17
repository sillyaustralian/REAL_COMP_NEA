extends CanvasLayer

@onready var pause_menu = $"."
@onready var resume = $MarginContainer/VBoxContainer/Resume
@onready var options = $MarginContainer/VBoxContainer/Options
@onready var quit = $MarginContainer/VBoxContainer/Quit
@onready var random_button_1 = $sfx/random_button_1
@onready var random_button_2 = $sfx/random_button_2

func _process(delta):
	if GlobalVars.paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
		pause_menu.hide()

func _on_resume_pressed():
	random_button_2.play()
	GlobalVars.paused = false
	pause_menu.hide()
	Engine.time_scale = 1

func _on_quit_pressed():
	random_button_2.play()
	get_tree().quit()
