extends RigidBody2D

signal lander_crashed (vel: Vector2)
signal lander_landed (vel: Vector2)

@export var max_vertical_velocity := 40.0
@export var max_horizontal_velocity := 10.0
@export var fuel_on_board := 1000.0
@export var engine_burn_rate := 20.0
@export var directional_burn_rate := 5.0
@export var directional_thrust := 10.0
@export var engine_thrust := 50.0

var engine_thrust_vector := Vector2(0, - engine_thrust)
var crashed := false
var landed := false
var previous_velocity: Vector2

@onready var fuel_remaining := fuel_on_board

@export var hud: Control		# Assigned in the Inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	lander_crashed.connect(we_crashed)
	lander_landed.connect(we_landed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if crashed or landed: return
	
	printt(" physics_process -> Linear: ", linear_velocity, "   Prev: ", previous_velocity)
	previous_velocity = linear_velocity
	
	maneuver(delta)
	
	# Either one works at this point	
	#hud.call_deferred("emit_signal", "hud_velocity_fuel_changed", previous_velocity, fuel_remaining)
	hud.emit_signal("hud_velocity_fuel_changed", previous_velocity, fuel_remaining)

# We have landed (maybe)
func _on_detect_landing_body_entered(body):
	print("_on_detect_landing signal fired")
	if crashed or landed: return
	printt("_on_detect_landing(struts)", "Linear:", linear_velocity, "Prev:", previous_velocity)
	if (absf(previous_velocity.x) <= max_horizontal_velocity and 
		absf(previous_velocity.y) <= max_vertical_velocity):
		printt("if is true -> Linear:", linear_velocity, "Prev:", previous_velocity)
		emit_signal("lander_landed", linear_velocity)
	else:
		printt("if is false -> Linear:", linear_velocity, "Prev:", previous_velocity)
		emit_signal("lander_crashed", previous_velocity)


func _on_detect_side_contact_body_entered(body):
	if crashed or landed: return
	printt("_on_detect_side_contact -> Linear:", linear_velocity, "Prev:", previous_velocity)
	emit_signal("lander_crashed", previous_velocity)

func maneuver(delta) -> void:
	if Input.is_action_pressed("engine_control"):
		apply_central_impulse(engine_thrust_vector)
		fuel_remaining -= engine_burn_rate * delta
		
	var thrusters := Input.get_axis("go_left", "go_right")
	if  thrusters != 0.0:
		apply_central_impulse(Vector2(thrusters * directional_thrust, 0.0))
		fuel_remaining -= directional_burn_rate * delta

	
func we_crashed(vel: Vector2) -> void:
	print("we_crashed signal fired")
	crashed = true
	$Altimeter.altimeter_stopped.emit()
	hud.hud_velocity_fuel_changed.emit(vel, fuel_remaining)
	print("Crashed")
	
	
func we_landed(vel: Vector2) -> void:
	print("we_landed signal fired")
	landed = true
	$Altimeter.altimeter_stopped.emit()
	hud.hud_velocity_fuel_changed.emit(vel, fuel_remaining)
	print("Landed")

