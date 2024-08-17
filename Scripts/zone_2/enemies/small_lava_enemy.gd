extends Node2D

var small_lava_pellet = preload("res://Scenes/zone_2/enemies/small_lava_pellet.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	attack()

func attack():
	var pellet = small_lava_pellet.instantiate()
	pellet.position = global_position
	get_tree().root.call_deferred("add_child", pellet)
	await get_tree().create_timer(randi_range(1, 5)).timeout
	attack()
