extends ProgressBar


func _ready():
	pass


func _process(delta):
	if GlobalVars.lives == 3:
		value += 100
	elif GlobalVars.lives == 2:
		value -= 33
	elif GlobalVars.lives == 1:
		value -= 33
