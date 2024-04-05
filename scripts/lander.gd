class_name Lander
extends RigidBody2D


#region Description
# Everything that defines and controls the lander
#
# The lander has two sources of force in addition to gravity:
#	o Main engine (applies vertical thrust)
#	o Directional thrusters (applies lateral thrust)
#
# The player activates these forces through the player interface.
# Force is either on or off. No proportional force is available.
# Lateral thrust must be negated by applying lateral thrust in 
# the opposite direction. (NOTE: Later versions may provide
# friction from atmosphere to dampen thrust.)
#
# The goal is for the player to land the vehicle safely. This means 
# the vehicle must come in contact with the surface without exceeding
# upper limits for vertical and horizontal thrust. The vehicle must also
# be with a tilt limit. Exceeding these limits means the vehicle has
# crashed. The lander also crashes if one of its sides collides with
# the surface.
#endregion


#region signals, enums, constants, variables, and such

# signals

signal lander_crashed (vel: Vector2)
signal lander_landed (vel: Vector2)

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var max_vertical_velocity := 40.0
@export var max_horizontal_velocity := 10.0
@export var fuel_on_board := 1000.0
@export var engine_burn_rate := 20.0
@export var directional_burn_rate := 5.0
@export var directional_thrust := 10.0
@export var engine_thrust := 50.0
# Instead of finding the HUD node at runtime we assign the HUD pointer 
# with the Editor Inspector. From the scene containing Lander drag the 
# HUD node to this exposed variable.
@export var hud: Control

# public variables

# private variables

var engine_thrust_vector := Vector2(0, - engine_thrust)
var crashed := false
var landed := false
var previous_velocity: Vector2


# onready variables

@onready var fuel_remaining := fuel_on_board


# Virtual Godot methods

# _ready()
# Called when node is ready
#
# Parameters
#		None
# Return
#		None
#==
# Connect to our signals' handling functions
func _ready():
	lander_crashed.connect(we_crashed)
	lander_landed.connect(we_landed)


# _physics_process(delta)
# Called once per physics frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# Step 1: Ignore if we have landed or crashed (i.e. no longer flying)
# Step 2: Preserve the previous velocity for HUD purposes
# Step 3: Accept user inputs to maneuver the lander
# Step 4: Update the HUD
func _physics_process(delta):
# Step 1
	if crashed or landed: return
# Step 2
	printt(" physics_process -> Linear: ", linear_velocity, "   Prev: ", previous_velocity)
	previous_velocity = linear_velocity
# Step 3
	_maneuver(delta)
# Step 4
	hud.emit_signal("hud_velocity_fuel_changed", previous_velocity, fuel_remaining)


# Built-in Signal Callbacks

# _on_detect_landing_body_entered(body)
# Our struts (DetectLanding) have collided with the surface.
# Determine if we landed safely by comparing our velocity with the
# maximum limits.
#
# Parameters
#	body: Node2D					Body we collided with
# Return
#	None
#==
# Step 1: Ignore if we have crashed or landed
# Step 2: 
func _on_detect_landing_body_entered(_body):
	print("_on_detect_landing signal fired")
# Step 1
	if crashed or landed: return
# Step 2: See if we landed within maximum limits
#	If so, emit we have landed.
#	If not, emit we have crashed.
	printt("_on_detect_landing(struts)", "Linear:", linear_velocity, "Prev:", previous_velocity)
	if (absf(previous_velocity.x) <= max_horizontal_velocity and 
		absf(previous_velocity.y) <= max_vertical_velocity):
		printt("if is true -> Linear:", linear_velocity, "Prev:", previous_velocity)
		emit_signal("lander_landed", linear_velocity)
	else:
		printt("if is false -> Linear:", linear_velocity, "Prev:", previous_velocity)
		emit_signal("lander_crashed", previous_velocity)


# _on_detect_side_contact_body_entered(body)
# Our body (DetectSideContact) has collided with the surface.
# This is always a crash.
#
# Parameters
#	body: Node2D					Body we collided with
# Return
#	None
#==
# Step 1: Ignore if we have already crashed.
#	However, if we have landed 'safely' then we override it because we may
#	have rolled during landing, or touched a side while landing.
# Step 2: Emit that we have crashed
func _on_detect_side_contact_body_entered(_body):
# Step 1
	if crashed: return
# Step 2
	printt("_on_detect_side_contact -> Linear:", linear_velocity, "Prev:", previous_velocity)
	emit_signal("lander_crashed", previous_velocity)


# Custom Signal Callbacks


# we_crashed(vel)
# Record that the lander has crashed
#
# Parameters
#	vel: Vector2					Velocity at time of crash
# Return
#	None
#==
# Step 1: Set flag that we have crashed	
# Step 2: Tell the Altimeter to stop updating HUD
# Step 3: Update HUD with velocity and fuel values
func we_crashed(vel: Vector2) -> void:
# Step 1
	print("we_crashed signal fired")
	crashed = true
# Step 2
	$Altimeter.altimeter_stopped.emit()
# Step 3
	hud.hud_velocity_fuel_changed.emit(vel, fuel_remaining)
	print("Crashed")
	
	
# we_landed(vel)
# Record that the lander has successfully landed
#
# Parameters
#	vel: Vector2					Velocity at time of landing
# Return
#	None
#==
# Step 1: Set flag that we have crashed	
# Step 2: Tell the Altimeter to stop updating HUD
# Step 3: Update HUD with velocity and fuel values
func we_landed(vel: Vector2) -> void:
# Step 1
	print("we_landed signal fired")
	landed = true
# Step 2
	$Altimeter.altimeter_stopped.emit()
# Step 3
	hud.hud_velocity_fuel_changed.emit(vel, fuel_remaining)
	print("Landed")
	
# Public Methods


# Private Methods

# _maneuver(delta)
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
func _maneuver(delta) -> void:
# Step 1
	if Input.is_action_pressed("engine_control"):
		apply_central_impulse(engine_thrust_vector)
		fuel_remaining -= engine_burn_rate * delta
# Step 2
	var thrusters := Input.get_axis("go_left", "go_right")
	if  thrusters != 0.0:
		apply_central_impulse(Vector2(thrusters * directional_thrust, 0.0))
		fuel_remaining -= directional_burn_rate * delta


# Subclasses

