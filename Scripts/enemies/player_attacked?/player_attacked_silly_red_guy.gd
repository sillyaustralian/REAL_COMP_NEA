extends Area2D

@onready var silly_red_guy = $".."


func damaged():
	print("taken damage L")
	silly_red_guy.damaged()
