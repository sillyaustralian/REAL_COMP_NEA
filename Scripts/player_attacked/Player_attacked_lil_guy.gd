extends Area2D
@onready var lil_guy = $".."

func damaged():
	lil_guy.damaged()
