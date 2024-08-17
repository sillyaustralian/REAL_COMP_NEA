extends Node

var spikes = false
var hit_spikes = false

var invincibility = false
#creates global variables; can be adjusted and called from any script
var is_dead = false #sets player state to not dead
var lives = 3 #lives
var in_transition = false #checks if player is in a transition (for black screens)


var dash_unlocked = false #checks if dash is unlocked

var respawn = false #checks if player is respawning
var respawn_needed = false #checks if player needs to respawn
var respawn_point = Vector2(0, 0) #sets template respawn point for the player

#combat
var damage = 10 #sets initial player damage
var health = 3 #sets health of player
var is_attacking = false #determines whether player is currently attacking
var hitbox = "" #creates template variable for hitbox instantiation
var has_sword = true #checks if player has sword when trying to attack

var healing = false

var something_dying = false #checks if an entity is dying

var can_move = true #allows cutscenes to occur naturally, stops player being able to move during them

var dash_pop_up_allowed = true #determines whether to play the dash pop-up in the scene

var goat_dead = false


#dialogue_box
var dialogue_box = " "
var show_dialogue = false
var next_line_of_dialogue = false
var player_ready_for_dialogue = false
var dialogue_playing = false
var remove_box = false
var dialogue_num = 0
var hit_the_floor = false
var who_talking = ""

#respawn determiners (location)
var zone_1_main_L = false
var z1_subzone_2_into_1 = false
var transition_respawn_point = Vector2(-10, -15)
var change_cam = false

var last_cam_limit_bottom = 150
var last_cam_limit_top = -300
var last_cam_limit_right = 10000000
var last_cam_limit_left = -760
var cam_zoom_x = 5
var cam_zoom_y = 5


#USER INTERFACE
var heal_potion_count = 0
var fully_healed = false
var paused = false

#TUTORIAL
var tutorial_over = false

#first boss
var first_time = true
var second_time = false
var third_time = false
var boss_ready = false

#dying
var fading = false
