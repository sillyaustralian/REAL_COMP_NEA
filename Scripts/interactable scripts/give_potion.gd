extends Area2D

@onready var chest_closed = $"../chest_closed"
@onready var chest_opened = $"../chest_opened"
@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"

var chest_can_be_opened = true
var interact_with_chest = false

func _ready():
	chest_closed.visible = true
	chest_opened.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and interact_with_chest:
		audio_stream_player_2d.play()
		chest_can_be_opened = false
		chest_closed.visible = false
		chest_opened.visible = true
		if GlobalVars.heal_potion_count < 4:
			GlobalVars.heal_potion_count = 4
		GlobalVars.player_ready_for_dialogue = true
		GlobalVars.next_line_of_dialogue = true
		GlobalVars.dialogue_num = 0
		GlobalVars.who_talking = "Chests"
		chest_opened = true
		queue_free()

func _on_body_entered(body):
	if body.has_node("is_player") and chest_can_be_opened:
		interact_with_chest = true

func _on_body_exited(_body):
	interact_with_chest = false
