class_name Altimeter
extends RayCast2D


#region Description
# Determine the distance between the lander and the surface directly
# beneath it.
#endregion


#region signals, enums, constants, variables, and such

# signals

signal altimeter_stopped

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

var _hud: Control
var _active := true

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
# Get pointer to the HUD from the parent
# Connect to our altimeter_stopped function
func _ready():
	_hud = get_parent().hud
	altimeter_stopped.connect(_make_inactive)


# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float            Seconds elapsed since last frame
# Return
#	None
#==
# Step 1: Don't run if we are inactive
# Step 2: Calculate distance to the surface
# Step 3: Display the altitude in the HUD
func _process(_delta):
# Step 1
	if !_active: return
# Step 2
	var origin = global_position
	var collision_point = get_collision_point()
	var distance = origin.distance_to(collision_point)
# Step 3
	_hud.hud_altitude_changed.emit(float(distance))


# Built-in Signal Callbacks


# Custom Signal Callbacks

func _make_inactive() -> void:
	_hud.hud_altitude_changed.emit(0.0)
	_active = false

# Public Methods


# Private Methods
