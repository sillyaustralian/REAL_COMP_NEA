extends Area2D
@onready var projectile_launcher_guy = $".."

func damaged():
	projectile_launcher_guy.damaged()
