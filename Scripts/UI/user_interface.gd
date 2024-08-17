extends CanvasLayer
@onready var user_interface = $"."

#Heart 1
@onready var heart_1 = $Lives/Heart1/Heart1
@onready var heart_1_broken = $Lives/Heart1/Heart1_broken
@onready var heart_1_empty = $Lives/Heart1/Heart1_Empty

#Heart 2
@onready var heart_2 = $Lives/Heart2/Heart2
@onready var heart_2_broken = $Lives/Heart2/Heart2_broken
@onready var heart_2_empty = $Lives/Heart2/Heart2_Empty

#Heart 3
@onready var heart_3 = $Lives/Heart3/Heart3
@onready var heart_3_broken = $Lives/Heart3/Heart3_broken
@onready var heart_3_empty = $Lives/Heart3/Heart3_Empty


#HEART POTION
@onready var heals_count = $heal_potions/heals_count
@onready var heal_potion_sprite = $heal_potions/heal_potion_sprite


func _ready():
	heals_count.text = "x " + str(GlobalVars.heal_potion_count)
	if GlobalVars.lives < 3:
		heart_1.visible = false
		heart_1_empty.visible = true
	if GlobalVars.lives < 2:
		heart_2.visible = false
		heart_2_empty.visible = true
	else:
		heart_1.visible = true
		heart_2.visible = true
		heart_3.visible = true
		heart_1_empty.visible = false
		heart_2_empty.visible = false
		heart_3_empty.visible = false

func _process(_delta):
	if GlobalVars.dialogue_playing:
		heals_count.text = ""
		heal_potion_sprite.visible = false
		heart_1.visible = false
		heart_2.visible = false
		heart_3.visible = false
		heart_1_empty.visible = false
		heart_2_empty.visible = false
		heart_3_empty.visible = false
	else:
		heals_count.text = "x " + str(GlobalVars.heal_potion_count)
		heal_potion_sprite.visible = true
		if GlobalVars.lives == 3:
			heart_1.visible = true
			heart_2.visible = true
			heart_3.visible = true
		if GlobalVars.lives == 2:
			heart_1_empty.visible = true
			heart_1.visible = false
			heart_2.visible = true
			heart_3.visible = true
		if GlobalVars.lives == 1:
			heart_1_empty.visible = true
			heart_2_empty.visible = true
			heart_2.visible = false
			heart_3.visible = true
		elif GlobalVars.lives == 0:
			heart_3.visible = false
			heart_1_empty.visible = true
			heart_2_empty.visible = true
			heart_3_empty.visible = true
	animations()

func animations():
	if GlobalVars.invincibility:
		if GlobalVars.lives == 2:
			heart_1_broken.play("Heart_broken")
		elif GlobalVars.lives == 1:
			heart_2_broken.play("Heart_broken")
		elif GlobalVars.lives == 0:
			heart_3_broken.play("Heart_broken")
	if GlobalVars.healing:
		if GlobalVars.lives == 2:
			heart_1_broken.play("Healing_heart")
			await get_tree().create_timer(0.4).timeout
			if GlobalVars.fully_healed:
				heart_1_broken.play("blank")
				heart_1.visible = true
			else:
				pass
		elif GlobalVars.lives == 1:
			heart_2_broken.play("Healing_heart")
			await get_tree().create_timer(0.4).timeout
			if GlobalVars.fully_healed:
				heart_2_broken.play("blank")
				heart_2.visible = true
			else:
				pass
	elif not GlobalVars.healing:
		heart_1_broken.play("blank")
		heart_2_broken.play("blank")
