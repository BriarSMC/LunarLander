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

signal reset_level_requested
signal lander_crashed (vel: Vector2)
signal lander_landed (vel: Vector2)

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var max_vertical_velocity := 400.0
@export var max_horizontal_velocity := 100.0
@export var starting_fuel_on_board := 1000.0
@export var engine_burn_rate := 20.0
@export var directional_burn_rate := 5.0
@export var directional_thrust := 20.0
@export var engine_thrust := 50.0
@export var zoom_altitude := 200.0
# Instead of finding the node at runtime we assign the node's pointer 
# with the Editor Inspector. From the scene containing Lander drag the 
# node to this exposed variable.
@export var hud: CanvasLayer
@export var terrain: StaticBody2D
@export var camera: Camera

# public variables

# private variables

var fuel_on_board: float
var engine_thrust_vector := Vector2(0, - engine_thrust)
var lander_state: int = Constant.lander_states.INFLIGHT
var engines_shutdown := false
var previous_velocity: Vector2
var game_over := false
var fuel_remaining: float


# onready variables

@onready var lander_starting_position := position
@onready var lander_starting_rotation := rotation
@onready var lander_starting_velocity := linear_velocity
@onready var lander_starting_angular_velocity := angular_velocity 
@onready var engines = [$Engines/MainEngine, $Engines/LeftThruster, $Engines/RightThruster]
@onready var maneuver = $SupportingScripts/Maneuver
@onready var engine_flame = $SupportingScripts/EngineFlame

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
# Connect to our signals' handling functions
func _ready():
	reset_level_requested.connect(reset_level)
	lander_crashed.connect(we_crashed)
	lander_landed.connect(we_landed)
	reset_level()


# _physics_process(delta)
# Called once per physics frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# Step 0: Ignore if game is over
# Step 1: Preserve the previous velocity for HUD purposes
# Step 2: Maneuver the lander and zoom camera if needs be
# Step 3: Update the HUD
# Step 4: Check lander state
func _physics_process(delta):
# Step 0
	if game_over: return
# Step 1
	previous_velocity = linear_velocity
# Step 2
	if not engines_shutdown:
		maneuver.maneuver(delta)
	camera.altitude_zoom($Altimeter.distance)
# Step 3
	hud.emit_signal("hud_velocity_fuel_changed", previous_velocity, fuel_remaining)
# Step 4
	lander_state = check_lander_state()
	if lander_state != Constant.lander_states.INFLIGHT:
		set_game_over_state()
	

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
# Step 1: Ignore if we not in flight
# Step 2: 
#	Freeze the HUD
#	Shut the engines down
# Step 3: See if we landed safely or crashed
func _on_detect_landing_body_entered(_body):
# Step 1
	if lander_state != Constant.lander_states.INFLIGHT: return
# Step 2
	hud.hud_freeze_requested.emit()
	engines_shutdown = true
# Step 3: See if we landed within maximum limits
#	If so, emit we have landed.
#	If not, emit we have crashed.
	if (absf(previous_velocity.x) <= max_horizontal_velocity and 
		absf(previous_velocity.y) <= max_vertical_velocity):
		emit_signal("lander_landed", previous_velocity)
	else:
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
#	Shutdown the engines
#	Freeze the HUD
# Step 2: Emit that we have crashed
func _on_detect_side_contact_body_entered(_body):
# Step 1
	if lander_state == Constant.lander_states.CRASHED: return
	hud.hud_freeze_requested.emit()
	engines_shutdown = true
# Step 2
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
# Step 1: 
#	Set flag that we have crashed	
#	Stop the engines
# Step 2: Tell the Altimeter to stop updating HUD
# Step 3: Update HUD 
func we_crashed(vel: Vector2) -> void:
# Step 1
	lander_state = Constant.lander_states.CRASHED
	engine_flame.throttle(Constant.selected_engine.ALL, false)
	camera.zoom_in.emit()
# Step 2
	$Altimeter.altimeter_stopped.emit()
# Step 3
	hud.hud_velocity_fuel_changed.emit(previous_velocity, fuel_remaining)
	
	
# we_landed(vel)
# Record that the lander has successfully landed
#
# Parameters
#	vel: Vector2					Velocity at time of landing
# Return
#	None
#==
# Step 1: 
#	Set flag that we have crashed	
#	Stop the engines
# Step 2: Tell the Altimeter to stop updating HUD
# Step 3: Update HUD with velocity and fuel values
func we_landed(vel: Vector2) -> void:
# Step 1
	lander_state = Constant.lander_states.LANDED
	engine_flame.throttle(Constant.selected_engine.ALL, false)
# Step 2
	$Altimeter.altimeter_stopped.emit()
# Step 3
	hud.hud_velocity_fuel_changed.emit(previous_velocity, fuel_remaining)
	
# Public Methods


# Private Methods


# check_lander_state() -> enum:
# Check to see if we need to end the game.
# Did lander:
#	o Still in flight
#	o Land safely
#	o Crash
#	o Go off screen
#
# Parameters
#	None
# Return
#	lander_state: enum
#==
# Check in order of Severe to Normal and return the appropriate state
func check_lander_state() -> int: 
	if (position.y < -200.0 or
		position.x < -terrain.get_terrain_width() / 2.0 or 
		position.x > terrain.get_terrain_width() / 2.0):
		print("Left Screen at: ", position)
		return Constant.lander_states.LEFTSCREEN
	else:
		return lander_state
		
	

# set_game_over_state()
# Do whatever is needed when a game is over
#
# Parameters
#	param: type						Description
# Return
#	None
#	value							Description
#==
# Don't do anything until lander stops moving or
#	we went off an edge somewhere
# Indicate game is over
# Stop the engine and thrusters
# Call HUD depending on what happened
func set_game_over_state() -> void:
	if lander_state != Constant.lander_states.LEFTSCREEN and not sleeping:
			return
	hud.emit_signal("hud_velocity_fuel_changed", previous_velocity, fuel_remaining)
	sleeping = true # in case if was LEFTSCREEN
	$LanderImage.visible = false
	game_over = true
	engine_flame.throttle(Constant.selected_engine.ALL, false)
	match lander_state:
		Constant.lander_states.LEFTSCREEN:
			hud.hud_gameover_changed.emit("Game Over\nYou Flew Into Space", false)
		Constant.lander_states.CRASHED:
			$Explosion.play("explode")
			Audioplayer.explosion()
			$LanderImage.visible = false
			hud.hud_gameover_changed.emit("Game Over\nYou Crashed!", false)
		Constant.lander_states.LANDED:
			hud.hud_gameover_changed.emit("You landed safely!", true)


# reset_level()
# Reset level for new game
#
# Parameters
#	None
# Return
#	None
#==
# Set variables
# Set objects
func reset_level() -> void:
	fuel_on_board = starting_fuel_on_board
	lander_state = Constant.lander_states.INFLIGHT
	engines_shutdown = false
	game_over = false
	fuel_remaining = fuel_on_board
	
	$LanderImage.visible = true
	position = lander_starting_position
	rotation = lander_starting_rotation 
	linear_velocity = lander_starting_velocity
	angular_velocity = lander_starting_angular_velocity	
	engine_flame.throttle(Constant.selected_engine.ALL, false)
	camera.zoom_out.emit()
	$Altimeter.reset_altimeter()
	terrain.new_terrain_requested.emit()
	
# Subclasses

