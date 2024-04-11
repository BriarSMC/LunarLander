class_name PlayLevel
extends Node2D

#region Description
# This script's purpose is to handle starting a new level and pausing the game
#
# VERY IMPORTANT: PlayLevel and all nodes under it must be set PROCESS=ALWAYS,
#	EXCEPT FOR Lander which must be set PROCESS=PAUSABLE
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

@onready var lander := $Lander
@onready var panel := $StartGameUI/StartGamePanel
@onready var start_btn := $StartGameUI/StartGamePanel/StartGameContainer/StartButton
@onready var resume_btn := $StartGameUI/Resume

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
# Have start button get the focus
# Don't display resume button
# Start the level off paused
func _ready():
	display_new_start_values()
	start_btn.grab_focus()
	resume_btn.visible = false
	get_tree().paused = true


# _input(event)
# Capture inputs
# 
# Specifically the start/pause button
#
# Parameters
#	event: InputEvent				What user input just happened
# Return
#	None
#==
# Is the input the play/pause button?
# 	If so, toggle the tree's paused stqte and the resume button's visibility
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start_pause_game"):			
		get_tree().paused = not get_tree().paused
		resume_btn.visible = get_tree().paused
	
# Built-in Signal Callbacks

# Turn off the start game panel
# Unpause the game
func _on_start_button_pressed():
	panel.visible = false
	get_tree().paused = false

# Turn off the resume button
# Unpause the game
func _on_resume_pressed():
	resume_btn.visible = false
	get_tree().paused = false
	
	
# Custom Signal Callbacks


# Public Methods

# display_new_start_values()
# Set various StartGameContainer values
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func display_new_start_values() -> void:
	$StartGameUI/StartGamePanel/StartGameContainer/VVelocityMax.text = "    Vertical: " + str(Config.max_vertical_velocity)
	$StartGameUI/StartGamePanel/StartGameContainer/HVelocityMax.text = "    Horizontal: " + str(Config.max_horizontal_velocity)



# Private Methods


# Subclasses

