extends CanvasLayer

@onready var color_rect = $ColorRect

const fade_rate = 0.1
var fade_timer = 0.0

var fade_in = true
var fade_out = false

func _ready():
	color_rect.modulate.a = 0.0

func _process(delta):
	if GlobalVars.fading:
		if fade_in:
			if fade_timer < 1:
				fade_timer += fade_rate
				color_rect.modulate.a = min(fade_timer / 1.0, 1.0)
				print_debug(fade_timer)
			elif fade_timer >= 1:
				GlobalVars.respawn = true
				fade_in = false
				fade_out = true
		elif fade_out:
			if fade_timer > 0:
				fade_timer -= fade_rate
				color_rect.modulate.a = min(fade_timer / 1.0, 1.0)
			else:
				GlobalVars.fading = false
				fade_in = true
				fade_out = false
