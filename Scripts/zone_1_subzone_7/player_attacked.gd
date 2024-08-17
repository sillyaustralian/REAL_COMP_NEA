extends Area2D

@onready var dwarven_boss = $".."

func damaged():
	dwarven_boss.damaged()
