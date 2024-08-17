extends Area2D
@onready var goat_enemy = $".."

func damaged():
	print("taken damage")
	goat_enemy.damaged()
