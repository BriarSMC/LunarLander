extends RayCast2D


signal altimeter_stopped

var hud: Control
var active := true

# Called when the node enters the scene tree for the first time.
func _ready():
	hud = get_parent().hud
	altimeter_stopped.connect(make_inactive)


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !active: return
	
	var origin = global_position
	var collision_point = get_collision_point()
	var distance = origin.distance_to(collision_point)
	
	hud.hud_altitude_changed.emit(float(distance))


func make_inactive() -> void:
	hud.hud_altitude_changed.emit(0.0)
	active = false
