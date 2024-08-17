extends Node

@onready var player = $"."

var db
var data_path = "res://Database/Dialogue.db"

func _ready():
	db = SQLite.new()
	db.path = data_path

func _process(delta):
	if GlobalVars.next_line_of_dialogue and GlobalVars.player_ready_for_dialogue:
		GlobalVars.dialogue_num += 1
		print_debug(GlobalVars.dialogue_num)
		GlobalVars.remove_box = false
		print("PRINTING DATA")
		print_data()

func print_data():
	GlobalVars.player_ready_for_dialogue = false
	GlobalVars.next_line_of_dialogue = false
	print_debug("PRINT DATA?")
	if db.open_db():
		if GlobalVars.who_talking == "GERALD":
			if not GlobalVars.remove_box:
				var query = db.query("SELECT Dialogue FROM Dialogue_Gerald WHERE DLNUM == %d;" % GlobalVars.dialogue_num)
				if query:
					for row in db.query_result:
						GlobalVars.dialogue_box = row["Dialogue"]
						print(GlobalVars.dialogue_box)
						if GlobalVars.dialogue_box == "null":
							GlobalVars.remove_box = true
							print("removed box")
						else:
							GlobalVars.show_dialogue = true
				else:
					print("Query failed")
		elif GlobalVars.who_talking == "Chests":
			if not GlobalVars.remove_box:
				var query = db.query("SELECT Message FROM Chests WHERE DLNUM == %d;" % GlobalVars.dialogue_num)
				if query:
					for row in db.query_result:
						GlobalVars.dialogue_box = row["Message"]
						print(GlobalVars.dialogue_box)
						if GlobalVars.dialogue_box == "null":
							GlobalVars.remove_box = true
							print("removed box")
						else:
							GlobalVars.show_dialogue = true
				else:
					print("Query failed")
		elif GlobalVars.who_talking == "BRUTE":
			if not GlobalVars.remove_box:
				print_debug("bruting")
				var query = db.query("SELECT Dialogue FROM Dwarven_brute WHERE DLNUM == %d;" % GlobalVars.dialogue_num)
				if query:
					print_debug(query)
					for row in db.query_result:
						GlobalVars.dialogue_box = row["Dialogue"]
						print_debug(GlobalVars.dialogue_box)
						if GlobalVars.dialogue_box == "null":
							GlobalVars.remove_box = true
							GlobalVars.boss_ready = true
							print_debug("removed box")
						else:
							GlobalVars.show_dialogue = true
				else:
					print_debug("Query failed")
		db.close_db()
	else:
		print_debug("Failed to open database")
