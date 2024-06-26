class_name StartGame
extends CanvasLayer



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

const help_screen = preload("res://scenes/help_screen.tscn")

const lander0 = preload("res://images/landers/lander_tn.png")
const lander1 = preload("res://images/landers/cohete_off_tn.png")
const landerfoc0 = preload("res://images/landers/lander_tn_focused.png")
const landerfoc1 = preload("res://images/landers/cohete_off_tn_focused.png")

const lander = [lander0, lander1]
const lander_focused = [landerfoc0, landerfoc1]

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

var current_lander = 0

# onready variables

@onready var max_landers = Constant.lander_spec.size()
@onready var version_number = ProjectSettings.get_setting("application/config/version")

#endregion


# Virtual Godot methods

# _ready()
# Called when node is ready
#
# Parameters
#		None
# Return
#		None
#==
# Set start button to grab focus
func _ready() -> void:
	$HBoxContainer/Menu/StartGame.grab_focus()
	$VersionNumber.text = version_number + "\t\n\n"
	load_level_list()
	Audioplayer.start_screen_music(true)
	

func _exit_tree():
	Audioplayer.start_screen_music(false)
	
	
# _input(event)
# Process input events
#
# Parameters
#	event: InputEvent				What input just happened
# Return
#	None
#==
# What the code is doing (steps)
func _input(event) -> void:
	if event.is_action_pressed("start_pause_game"):
		start_new_game()
		
	if event.is_action_pressed("quit_game"):
		exit_game()


# Built-in Signal Callbacks


# Change scene to play level when start button pressed
func _on_start_game_pressed():
	start_new_game()



func _on_quit_game_pressed():
	exit_game()



func _on_help_pressed():
	get_tree().change_scene_to_packed(help_screen)
	
	
# Force focus images
func _on_select_lander_focus_entered():
	$HBoxContainer/Landers/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/Landers/SelectLander.texture_focused = lander_focused[current_lander]



func _on_select_lander_mouse_exited():
	$HBoxContainer/Landers/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/Landers/SelectLander.texture_focused = lander_focused[current_lander]


#==
# Ignore if there is only 1 lander to choose from
# If current lander is the last lander, then point to the first lander
# Otherwise, point to the next lander
# Set the new lander index in the Config
# Set the new image in the button
func _on_select_lander_pressed():
	if max_landers <= 1:
		return
		
	if current_lander == max_landers - 1:
		current_lander = 0
	else:
		current_lander += 1
		
	Config.lander_type = current_lander
	$HBoxContainer/Landers/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/Landers/SelectLander.texture_focused = lander_focused[current_lander]



# Set the new level
func _on_level_item_selected(index):
	Config.level = $HBoxContainer/Difficulty/Level.get_item_text(index)
	display_level_description()

# Custom Signal Callbacks


# Public Methods


# Private Methods

# start_new_game()
# Start a new game
#
# Parameters
#	None
# Return
#	None
#==
# Switch to the play level scene
func start_new_game() -> void:
	get_tree().change_scene_to_packed(Preloads.play_level_scene)
	
# exit_game()
# Exit the game
#
# Parameters
#	None
# Return
#	None
#==
# TTFN
func exit_game() -> void:
	get_tree().quit()
	
	
# load_level_list()
# Load the item list from Config info
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func load_level_list() -> void:
	$HBoxContainer/Difficulty/Level.clear()
	for i in Config.difficulty.keys():
		$HBoxContainer/Difficulty/Level.add_item(i)
	$HBoxContainer/Difficulty/Level.select(0)
	Config.level = "EASY"
	display_level_description()


func display_level_description() -> void:
	$HBoxContainer/Difficulty/LevelDescription.text = \
		"Max Vertical Velocity: " + str(Config.difficulty[Config.level]['MAXV']) + \
		"\nMax Horizontal Velocity: " + str(Config.difficulty[Config.level]['MAXH']) + \
		"\nStarting Fuel: " + str(Config.difficulty[Config.level]['FUEL'])
# Subclasses

