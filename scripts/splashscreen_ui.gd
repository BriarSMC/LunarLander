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

var play_level := preload("res://scenes/play_level.tscn")

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
# What the code is doing (steps)
# NOTE: Child must call super._ready() if it defines own _ready() method
func _ready() -> void:
	pass


# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# What the code is doing (steps)
# NOTE: Child must call super._ready() if it defines own _ready() method
func _process(delta) -> void:
	pass


# Built-in Signal Callbacks



func _on_start_game_pressed():
	get_tree().change_scene_to_packed(play_level)



func _on_quit_game_pressed():
	get_tree().quit()
	
	
## Custom Signal Callbacks


# Public Methods


# Private Methods


# Subclasses
