class_name HUD
extends CanvasLayer


#region Description
# Update HUD (Heads-Up Display) values
#
# Scripts in this project update HUD values by emitting the appropriate
# HUD signals.
#endregion


#region signals, enums, constants, variables, and such

# signals

signal hud_velocity_fuel_changed (linear_velocity: Vector2, fuel_on_board: float)
signal hud_altitude_changed (altitude: float)
signal hud_gameover_changed (message: String, success: bool)

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

# onready variables

# Pointers to HUD components
@onready var vvel_value := $UI/HBoxContainer/Values/VerticalVelocity
@onready var hvel_value := $UI/HBoxContainer/Values/HorzontalVelocity
@onready var fuel_value := $UI/HBoxContainer/Values/FuelRemaning
@onready var altitude	:= $UI/HBoxContainer/Values/Altitude
@onready var gameover 	:= $UI/GameOver

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
# Connect to our signal handling functions
func _ready():
	hud_velocity_fuel_changed.connect(_new_velocity_fuel_values)
	hud_altitude_changed.connect(_new_altitude)
	hud_gameover_changed.connect(_gameover)


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods


# Private Methods

# _new_velocity_fuel_valus(vel, fuel)
# Display velocity and remaining fuel on the HUD
#
# Parameters
#	vel: Vectore2					Velocity to display
#	fuel: float						Remaining fuel on board
# Return
#	None
#==
# Step 1: Determine which arrows to display
#	The HUD uses UNICODE arrow characters as additional information for the
#	velocity values. Defaults are set to spaces. We then set the appropriate
#	UNICODE arrow characters based on the vector values.
# Step 2: Set the HUD label values to the velocity and fuel
#	Append the appropriate UNICODE arrow characters to the velocity values
func _new_velocity_fuel_values(vel: Vector2, fuel: float) -> void:
# Step 1	
	var v_dir: int = 32
	var h_dir: int = 32
	if vel.y < 0.0: 
		v_dir = 0x2191
	else:
		v_dir = 0x2193
	if vel.x > 0:
		h_dir = 0x2192
	else:
		h_dir = 0x2190
# Step 2		
	vvel_value.text = ("%6.1f" % absf(vel.y)) + String.chr(v_dir)
	hvel_value.text = ("%6.1f" % absf(vel.x)) + String.chr(h_dir)
	fuel_value.text = "%6.1f" % fuel


# _new_altitude(alt)
# Display altitude on the HUD
#
# Parameters
#	alt: float						Altitude value to display
# Return
#	None
#==
# Set the HUD label value for altitude
func _new_altitude(alt: float) -> void:
	altitude.text = "%.1f" % alt 

# _gameover(message)
# Display altitude on the HUD
#
# Parameters
#	message: String					Message to display in game over box
# Return
#	None
#==
# Set the HUD label value for game over
func _gameover(message: String, success: bool = false) -> void:
	if success:
		gameover.add_theme_color_override("font_color", Color.GREEN)
	gameover.text = message


# Subclasses

