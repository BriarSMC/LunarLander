class_name Altimeter
extends RayCast2D


#region Description
# Determine the distance between the lander and the surface directly
# beneath it.
#endregion


#region signals, enums, constants, variables, and such

# signals

signal altimeter_stopped
signal graphic_altimeter_requested (on_off: bool)

# enums

# constants

const reset_altitude_value = 9999999.9

# exports (The following properties must be set in the Inspector by the designer)

# public variables

var distance := reset_altitude_value

# private variables

var _hud: CanvasLayer
var _active := true
var _collision_point := Vector2.ZERO

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
	graphic_altimeter_requested.connect(graphic_altimeter)


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
	var origin = get_parent().global_position
	_collision_point = get_collision_point()
	distance = origin.distance_to(_collision_point)
	queue_redraw()
# Step 3
	_hud.hud_altitude_changed.emit(float(distance))


func _draw():
	if visible and _active:
		draw_line(position, to_local(_collision_point), Color.RED, 2.0)
	
# Built-in Signal Callbacks


# Custom Signal Callbacks

func _make_inactive() -> void:
	_hud.hud_altitude_changed.emit(0.0)
	_active = false
	

func graphic_altimeter(on_off: bool) -> void:
	if on_off:
		visible = true
	else:
		visible = false
		queue_redraw()

# Public Methods

func reset_altimeter() -> void:
	distance = reset_altitude_value
	_active = true
	visible = false

# Private Methods
