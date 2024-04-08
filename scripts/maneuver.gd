class_name Maneuver
extends Node2D


#region Description
# This module handles all the user input to control the flight of the lander.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var lander: Lander

# public variables

# private variables

# onready variables

#@onready var lander: Lander =  get_tree().get_root().find_node("Lander", true, true) as Lander

#endregion


# Virtual Godot methods


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# maneuver(delta)
# Apply forces to the lander based on the player's input (i.e. Move the lander)
#
# Parameters
#	delta: float					Time elapsed since last frame
# Return
#	None
#==
# Step 1: Check for main engine on. If so, 
#	o Apply force UP on the lander
#	o Deplete the fuel accordingly
# Step 2: Check for thrusters on. If so,
#	o Apply force laterally
#	o Deplete fuel accordingly
func maneuver(delta) -> void:
# Step 1
	if Input.is_action_pressed("engine_control"):
		lander.apply_central_impulse(lander.engine_thrust_vector)
		lander.fuel_remaining -= lander.engine_burn_rate * delta
		lander.engine_flame(Constant.selected_engine.MAIN, true)
	else:
		lander.engine_flame(Constant.selected_engine.MAIN, false)
# Step 2
	var thrusters := Input.get_axis("go_left", "go_right")
	var selected_thruster = 0
	if thrusters > 0: 
		selected_thruster = Constant.selected_engine.LEFT
	if thrusters < 0: 
		selected_thruster = Constant.selected_engine.RIGHT
	if  thrusters != 0.0:
		lander.apply_central_impulse(Vector2(thrusters * lander.directional_thrust, 0.0))
		lander.fuel_remaining -= lander.directional_burn_rate * delta
		lander.engine_flame(selected_thruster, true)
	else:
		lander.engine_flame(Constant.selected_engine.LEFT, false)
		lander.engine_flame(Constant.selected_engine.RIGHT, false)


# Private Methods


# Subclasses

