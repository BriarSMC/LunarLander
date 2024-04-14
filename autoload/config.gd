extends Node

var lander_type := 0


@export var difficulty = {
	"EASY" = {
		"MAXV" = 400.0,
		"MAXH" = 100.0,
		"FUEL" = 1000.0,
		"SEGMOD" = 1.0,
		"RANMOD" = 1.0,
	},
	"MEDIUM" = {
		"MAXV" = 300.0,
		"MAXH" = 75.0,
		"FUEL" = 500.0,
		"SEGMOD" = 0.8,
		"RANMOD" = 0.8,
	},
	"HARD" = {
		"MAXV" = 200.0,
		"MAXH" = 50.0,
		"FUEL" = 300.0,
		"SEGMOD" = 0.7,
		"RANMOD" = 0.6,
	},
}
var level := "EASY"


@export var max_terrain_width := 8.0
@export var min_segment_length := 30.0
@export var max_segment_length := 120.0
@export var min_segment_height := 30.0
@export var max_segment_height := 200.0
@export var coin_probability := 0.10


# load_specs(lander)
# Load lander specifications
#
# Parameters
#	lander: Lander					Lander object
# Return
#	None
#==
func load_specs(lander: Lander) -> void:
	var spec = Constant.lander_spec[str(int(Config.lander_type))]
	var image = lander.get_node("LanderImage")
	var bcoll = lander.get_node("BodyCollider")
	var lscoll = lander.get_node("LeftStrutCollider")
	var rscoll = lander.get_node("RightStrutCollider")
	var detectl = lander.get_node("DetectLanding/Struts")
	var detects = lander.get_node("DetectSideContact/Sides")
	var engine = lander.get_node("Engines/MainEngine")
	var lthrust = lander.get_node("Engines/LeftThruster")
	var rthrust = lander.get_node("Engines/RightThruster")
	
	image.texture = load("res://images/landers/" + spec["image"]["texture"])
	image.scale = Vector2(spec["image"]["scale"], spec["image"]["scale"])
	
	bcoll.shape.size.x = spec["body_collider"]["size"].x
	bcoll.shape.size.y = spec["body_collider"]["size"].y
	bcoll.position = spec["body_collider"]["position"]
	bcoll.rotation = deg_to_rad(spec["body_collider"]["rotation"])
	bcoll.scale = Vector2(spec["body_collider"]["scale"],spec["body_collider"]["scale"])
	bcoll.skew = spec["body_collider"]["skew"]

	lscoll.shape.size.x = spec["left_strut_collider"]["size"].x
	lscoll.shape.size.y = spec["left_strut_collider"]["size"].y
	lscoll.position = spec["left_strut_collider"]["position"]
	lscoll.rotation = deg_to_rad(spec["left_strut_collider"]["rotation"])
	lscoll.scale = Vector2(spec["left_strut_collider"]["scale"],spec["left_strut_collider"]["scale"])
	lscoll.skew = spec["left_strut_collider"]["skew"]

	rscoll.shape.size.x = spec["right_strut_collider"]["size"].x
	rscoll.shape.size.y = spec["right_strut_collider"]["size"].y
	rscoll.position = spec["right_strut_collider"]["position"]
	rscoll.rotation = deg_to_rad(spec["right_strut_collider"]["rotation"])
	rscoll.scale = Vector2(spec["right_strut_collider"]["scale"],spec["right_strut_collider"]["scale"])
	rscoll.skew = spec["right_strut_collider"]["skew"]

	detectl.shape.size.x = spec["detect_landing"]["size"].x
	detectl.shape.size.y = spec["detect_landing"]["size"].y
	detectl.position = spec["detect_landing"]["position"]
	detectl.rotation = deg_to_rad(spec["detect_landing"]["rotation"])
	detectl.scale = Vector2(spec["detect_landing"]["scale"],spec["detect_landing"]["scale"])
	detectl.skew = spec["detect_landing"]["skew"]

	detects.shape.size.x = spec["detect_side_collision"]["size"].x
	detects.shape.size.y = spec["detect_side_collision"]["size"].y
	detects.position = spec["detect_side_collision"]["position"]
	detects.rotation = deg_to_rad(spec["detect_side_collision"]["rotation"])
	detects.scale = Vector2(spec["detect_side_collision"]["scale"],spec["detect_side_collision"]["scale"])
	detects.skew = spec["detect_side_collision"]["skew"]
	
	engine.position = spec["main_engine"]["position"]
	engine.rotation = deg_to_rad(spec["main_engine"]["rotation"])
	engine.scale = Vector2(spec["main_engine"]["scale"],spec["main_engine"]["scale"])
	engine.skew = spec["main_engine"]["skew"]
	
	lthrust.position = spec["left_thruster"]["position"]
	lthrust.rotation = deg_to_rad(spec["left_thruster"]["rotation"])
	lthrust.scale = Vector2(spec["left_thruster"]["scale"],spec["left_thruster"]["scale"])
	lthrust.skew = spec["left_thruster"]["skew"]
	
	rthrust.position = spec["right_thruster"]["position"]
	rthrust.rotation = deg_to_rad(spec["right_thruster"]["rotation"])
	rthrust.scale = Vector2(spec["right_thruster"]["scale"],spec["right_thruster"]["scale"])
	rthrust.skew = spec["right_thruster"]["skew"]
