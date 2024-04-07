class_name Camera
extends Camera2D


#region Description
# Turn the game into a side-scroller by attaching this camera to the lander
#endregion


#region signals, enums, constants, variables, and such

# signals

signal zoom_in
signal zoom_out

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
# Connect to our signals
func _ready() -> void:
	zoom_in.connect(zoom_camera_in)
	zoom_out.connect(zoom_camera_out)


# Built-in Signal Callbacks


# Custom Signal Callbacks

# zoom_camera_in()
# Zoom the camera in
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func zoom_camera_in() -> void:
	#print("Zoom Camera In")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(3.0, 3.0), 1.0)
	
	
# zoom_camera_out()
# Zoom the camera out
#
# Parameters
#	None
# Return
#	None
#==
# What the code is doing (steps)
func zoom_camera_out() -> void:
	#print("Zoom Camera Out")
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", Vector2(1.0, 1.0), 1.0)
	
	
# Public Methods


# Private Methods


# Subclasses

