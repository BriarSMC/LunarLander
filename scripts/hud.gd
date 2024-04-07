class_name HUD
extends CanvasLayer


#region Description
# Update HUD (Heads-Up Display) values for play level
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

@export var lander: Lander
@export var game_over_leave_on_screen_time := 1.0
@export var buttons_display_delay_time := 0.4

# public variables

# private variables

# onready variables

# Pointers to HUD components
@onready var vvel_value 	:= $UI/Panel/HBoxContainer/Values/VerticalVelocity
@onready var hvel_value 	:= $UI/Panel/HBoxContainer/Values/HorzontalVelocity
@onready var fuel_value 	:= $UI/Panel/HBoxContainer/Values/FuelRemaning
@onready var altitude		:= $UI/Panel/HBoxContainer/Values/Altitude
@onready var gameover_panel := $GameOverPanel
@onready var gameover 		:= $GameOverPanel/GameOverText
@onready var buttons 		:= $UI/Buttons
@onready var play_again 	:= $UI/Buttons/PlayAgain
@onready var quit			:= $UI/Buttons/Quit

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
	
	gameover_panel.visible = false
	gameover.add_theme_font_size_override("font_size", 1)
	buttons.visible = false


# Built-in Signal Callbacks

# Display the start_game scene
func _on_play_again_pressed():
	start_new_game()


# Just exit the game
func _on_quit_pressed():
	exit_game()


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


# _gameover(message, success)
# Display end of game sequence
#
# Parameters
#	message: String					Message to display in game over box
#	success: bool					If true, make text green
# Return
#	None
#==
# Step 1: If success is true then change default text color to green
# Step 2: Set text in UI to message
# Step 3: Display the game over text
#	We hide the panel and set the font size to 1 in _ready()
#	Make the panel visible
#	Use a tween to increase the size of the text
# Step 4: Display the buttons
#	We hide the buttons in _ready()
#	Wait for the tween to finish
#	Hide the panel
#	Display the buttons
func _gameover(message: String, success: bool = false) -> void:
# Step 1
	if success:
		gameover.add_theme_color_override("font_color", Color.GREEN)
# Step 2
	gameover.text = message
# Step 3	
	gameover_panel.visible = true
	var tween = get_tree().create_tween()
	tween.tween_method(func(s: int): gameover.add_theme_font_size_override("font_size", s), 1, 160, 1.5)
# Step 4
	await tween.finished
	await get_tree().create_timer(game_over_leave_on_screen_time).timeout
	gameover_panel.visible = false
	await get_tree().create_timer(buttons_display_delay_time).timeout	
	buttons.visible = true
	play_again.grab_focus()
	

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
	buttons.visible = false
	gameover_panel.visible = false
	lander.reset_level_requested.emit()

	
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

