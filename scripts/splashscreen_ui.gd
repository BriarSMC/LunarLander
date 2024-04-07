class_name SplashScreenUI
extends CanvasLayer



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

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
	$HBoxContainer/StartGame.grab_focus()
	print(get_parent().name)

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
	
	
## Custom Signal Callbacks


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
