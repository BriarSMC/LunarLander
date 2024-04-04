extends Control

signal hud_values_changed (linearVelocity: Vector2, fuelOnBoard: float)
signal hud_altitude_changed (altitude: float)

@onready var vvel_value := $HBoxContainer/Values/VerticalVelocity
@onready var hvel_value := $HBoxContainer/Values/HorzontalVelocity
@onready var fuel_value := $HBoxContainer/Values/FuelRemaning
@onready var altitude  := $HBoxContainer/Values/Altitude

# Called when the node enters the scene tree for the first time.
func _ready():
	hud_values_changed.connect(new_hud_values)
	hud_altitude_changed.connect(new_altitude)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_hud_values(vel: Vector2, fuel: float) -> void:
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
		
	vvel_value.text = ("%6.1f" % absf(vel.y)) + String.chr(v_dir)
	hvel_value.text = ("%6.1f" % absf(vel.x)) + String.chr(h_dir)
	fuel_value.text = "%6.1f" % fuel

func new_altitude(alt: float) -> void:
	altitude.text = "%.1f" % alt
