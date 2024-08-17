extends Label

@onready var lives = $"."

func _ready():
	lives.text = "Lives: " + str(GlobalVars.lives) #initialises scene with lives count

func _process(_delta):
	lives.text = "Lives: " + str(GlobalVars.lives) #updates lives count each frame
