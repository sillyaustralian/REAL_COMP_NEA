extends Label

@onready var lives = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	lives.text = "Lives: " + str(GlobalVars.lives)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lives.text = "Lives: " + str(GlobalVars.lives)
