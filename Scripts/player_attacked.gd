extends Area2D
@onready var ghost = $".."

func damaged():
	print("taken damage L")
	ghost.damaged()
