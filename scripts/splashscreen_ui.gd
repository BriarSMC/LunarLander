class_name SplashScreenUI
extends CanvasLayer



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

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
	if event.is_action_pressed("start_game"):
		start_new_game()
		
	if event.is_action_pressed("quit_game"):
		exit_game()


# Built-in Signal Callbacks


# Change scene to play level when start button pressed
func _on_start_game_pressed():
	start_new_game()



func _on_quit_game_pressed():
	exit_game()
	
	
# Force focus images
func _on_select_lander_focus_entered():
	$HBoxContainer/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/SelectLander.texture_focused = lander_focused[current_lander]



func _on_select_lander_mouse_exited():
	$HBoxContainer/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/SelectLander.texture_focused = lander_focused[current_lander]


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
	$HBoxContainer/SelectLander.texture_normal = lander[current_lander]
	$HBoxContainer/SelectLander.texture_focused = lander_focused[current_lander]

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
	
	
# Subclasses





