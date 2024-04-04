extends RigidBody2D

signal LanderCrashed (vel: Vector2)
signal LanderLanded (vel: Vector2)

@export var maxVerticalVelocity := 40.0
@export var maxHorizontalVelocity := 10.0
@export var fuelOnBoard := 1000.0
@export var engineBurnRate := 20.0
@export var directionalBurnRate := 5.0
@export var directionalThrust := 10.0
@export var engineThrust := 50.0

var engineThrustVector := Vector2(0, - engineThrust)
var crashed := false
var landed := false
var previousVelocity: Vector2

@onready var fuelRemaining := fuelOnBoard

@export var HUD: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	LanderCrashed.connect(weCrashed)
	LanderLanded.connect(weLanded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if crashed or landed: return
	
	printt(" physics_process -> Linear: ", linear_velocity, "   Prev: ", previousVelocity)
	previousVelocity = linear_velocity
	
	maneuver(delta)
		
	#HUD.call_deferred("emit_signal", "hudValues", previousVelocity, fuelRemaining)
			

# We have landed (maybe)
func _on_detect_landing_body_entered(body):
	print("_on_detect_landing signal fired")
	if crashed or landed: return
	printt("_on_detect_landing(struts)", "Linear:", linear_velocity, "Prev:", previousVelocity)
	if (absf(previousVelocity.x) <= maxHorizontalVelocity and 
		absf(previousVelocity.y) <= maxVerticalVelocity):
		printt("if is true -> Linear:", linear_velocity, "Prev:", previousVelocity)
		emit_signal("LanderLanded", linear_velocity)
	else:
		printt("if is false -> Linear:", linear_velocity, "Prev:", previousVelocity)
		emit_signal("LanderCrashed", previousVelocity)


func _on_detect_side_contact_body_entered(body):
	if crashed or landed: return
	printt("_on_detect_side_contact -> Linear:", linear_velocity, "Prev:", previousVelocity)
	emit_signal("LanderCrashed", previousVelocity)

func maneuver(delta) -> void:
	if Input.is_action_pressed("engine_control"):
		apply_central_impulse(engineThrustVector)
		fuelRemaining -= engineBurnRate * delta
		
	var thrusters := Input.get_axis("go_left", "go_right")
	if  thrusters != 0.0:
		apply_central_impulse(Vector2(thrusters * directionalThrust, 0.0))
		fuelRemaining -= directionalBurnRate * delta

	
func weCrashed(vel: Vector2) -> void:
	print("weCrashed signal fired")
	crashed = true
	$Altimeter.stopAltimeter.emit()
	#HUD.hudValues.emit(vel, fuelRemaining)
	print("Crashed")
	
	
func weLanded(vel: Vector2) -> void:
	print("weLanded signal fired")
	landed = true
	$Altimeter.stopAltimeter.emit()
	#HUD.hudValues.emit(vel, fuelRemaining)
	print("Landed")

