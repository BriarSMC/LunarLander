extends Control

signal hudValues (linearVelocity: Vector2, fuelOnBoard: float)
signal hudAltitude (altitude: float)

@onready var vvelValue := $HBoxContainer/Values/VerticalVelocity
@onready var hvelValue := $HBoxContainer/Values/HorizontalVelocity
@onready var fuelValue := $HBoxContainer/Values/FuelRemaining
@onready var altitude := $HBoxContainer/Values/Altitude

# Called when the node enters the scene tree for the first time.
func _ready():
	hudValues.connect(newHudValues)
	hudAltitude.connect(newAltitude)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func newHudValues(vel: Vector2, fuel: float) -> void:
	var vDir: int = 32
	var hDir: int = 32
	if vel.y < 0.0: 
		vDir = 0x2191
	else:
		vDir = 0x2193
	if vel.x > 0:
		hDir = 0x2192
	else:
		hDir = 0x2190
		
	vvelValue.text = ("%6.1f" % absf(vel.y)) + String.chr(vDir)
	hvelValue.text = ("%6.1f" % absf(vel.x)) + String.chr(hDir)
	fuelValue.text = "%6.1f" % fuel

func newAltitude(alt: float) -> void:
	altitude.text = "%.1f" % alt
