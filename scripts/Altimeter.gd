extends RayCast2D


signal stopAltimeter

#var HUD: Control
var active := true

# Called when the node enters the scene tree for the first time.
func _ready():
	#HUD = get_parent().HUD
	stopAltimeter.connect(makeInactive)


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if !active: return
	
	var origin = global_position
	var collision_point = get_collision_point()
	var distance = origin.distance_to(collision_point)
	
	#HUD.hudAltitude.emit(float(distance))


func makeInactive() -> void:
	#HUD.hudAltitude.emit(0.0)
	active = false
