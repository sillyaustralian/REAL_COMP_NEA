extends CanvasLayer

@onready var character = $TextboxContainer/character

@onready var textbox_container = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Beginning
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/End
@onready var main_text = $TextboxContainer/MarginContainer/HBoxContainer/MainText

#gerald sounds
@onready var ho_huah = $"gerald_sfx/Ho Huah!!"
@onready var re_hm_weh_ha_hau = $"gerald_sfx/Re hm weh ha hau"
@onready var hm_wal_hm_wal_geeble_go = $"gerald_sfx/Hm wal hm wal geeble go"

#brute sounds
@onready var brute_1 = $dwarven_brute_sfx/Brute_1
@onready var brute_2 = $dwarven_brute_sfx/Brute_2
@onready var brute_3 = $dwarven_brute_sfx/Brute_3


const CHAR_READ_RATE = 0.03

enum text_state { 
	READY,
	READING,
	FINISHED
}

var current_state = text_state.READY

var skip = false #allowed for skipping text
#OLD METHOD: add_text("ATTENTION, ALL SUSSY GAMERS! WHAT HAVE YOU DONE WITH BIG CHUNGUS? FORTNITEFORTNIT")
var random_sfx

func _ready():
	print("STARTING STATE: READY") #ensuring everything starts up correctly
	hide_textbox() #gets rid of textbox on startup

func _process(_delta):
	if GlobalVars.show_dialogue:
		show_textbox() 
		diff_text_alg(GlobalVars.dialogue_box) 
	match current_state:
		text_state.READY:
			GlobalVars.dialogue_playing = false
			if GlobalVars.remove_box:
				hide_textbox()
				GlobalVars.who_talking = ""
				character.play("Auto_blank")
			if Input.is_action_just_pressed("ui_accept"):
				hide_textbox()
		text_state.READING:
			GlobalVars.dialogue_playing = true
			if Input.is_action_just_pressed("ui_accept"):
				skip = true
		text_state.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				main_text.text = ""
				change_state(text_state.READY)
				GlobalVars.player_ready_for_dialogue = true

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	main_text.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func diff_text_alg(next_text):
	GlobalVars.show_dialogue = false
	if GlobalVars.who_talking == "GERALD":
		character.play("Gerald")
		if "HAHA" in next_text:
			ho_huah.play()
		else:
			random_sfx = randi_range(1, 3) #TODO: discuss the failure of the dict, may revisit
			print(random_sfx)
			if random_sfx == 1: #TODO: please find a nicer way to do this
				ho_huah.play()
			elif random_sfx == 2:
				re_hm_weh_ha_hau.play()
			elif random_sfx == 3:
				hm_wal_hm_wal_geeble_go.play()
		print("PLAYING GERALD")
	elif GlobalVars.who_talking == "BRUTE":
		character.play("Dwarven_brute")
		random_sfx = randi_range(0, 2) #TODO: discuss the failure of the dict, may revisit
		print(random_sfx)
		if random_sfx == 0: #TODO: please find a nicer way to do this
			brute_1.play()
		elif random_sfx == 1:
			brute_2.play()
		elif random_sfx == 2:
			brute_3.play()
		print("PLAYING BRUTE")
	GlobalVars.show_dialogue = false
	change_state(text_state.READING)
	next_text = str(next_text)
	print_debug(next_text)
	for i in next_text.length():
		if not skip:
			await get_tree().create_timer(CHAR_READ_RATE).timeout
			main_text.text += next_text[i]
		else:
			if random_sfx == 1: #TODO: please find a nicer way to do this
				ho_huah.stop()
			elif random_sfx == 2:
				re_hm_weh_ha_hau.stop()
			elif random_sfx == 3:
				hm_wal_hm_wal_geeble_go.stop()
			main_text.text = next_text
			skip = false
			break
	if next_text.length() != 0:
		GlobalVars.next_line_of_dialogue = true
	change_state(text_state.FINISHED)
	return

func change_state(next_state):
	current_state = next_state
	match current_state: 
		text_state.READY:
			print("STATE = READY")
		text_state.READING:
			print("STATE = READING")
		text_state.FINISHED:
			print("STATE = FINISHED")
