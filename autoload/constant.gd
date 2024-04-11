extends Node


# enums

enum lander_states {INFLIGHT, LANDED, CRASHED, LEFTSCREEN}
enum selected_engine {MAIN, LEFT, RIGHT, ALL}

# constants

const zoom_altitude := 200.0

# Paths

const Lander = "/root/PlayLevel/Lander"

# Lander Data

const lander_spec = {
	"0" = {
		"image" = {
			"texture" = "lander.png",
			"scale" = 0.5,
		},
		"body_collider" = {
			"size" = Vector2(50,25),
			"position" = Vector2(0,0),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"left_strut_collider" = {
			"size" = Vector2(10,13),
			"position" = Vector2(-15,17),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 22.9
		},
		"right_strut_collider" = {
			"size" = Vector2(10,13),
			"position" = Vector2(15,17),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = -22.9
		},
		"detect_landing" = {
			"size" = Vector2(44,2),
			"position" = Vector2(0,23),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"detect_side_collision" = {
			"size" = Vector2(50,25),
			"position" = Vector2(0,-2.5),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"main_engine" = {
			"position" = Vector2(-1,63),
			"rotation" = 180.0,
			"scale" = 0.8,
			"skew" = 0
		},
		"left_thruster" = {
			"position" = Vector2(-43,0),
			"rotation" = -90.0,
			"scale" = 0.3,
			"skew" = 0
		},
		"right_thruster" = {
			"position" = Vector2(43,0),
			"rotation" = 90.0,
			"scale" = 0.3,
			"skew" = 0
		},
	},
	"1" = {
		"image" = {
			"texture" = "cohete_off.png",
			"scale" = 0.3,
		},
		"body_collider" = {
			"size" = Vector2(34, 46),
			"position" = Vector2(0,0),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"left_strut_collider" = {
			"size" = Vector2(8,13),
			"position" = Vector2(-12,20),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0
		},
		"right_strut_collider" = {
			"size" = Vector2(8,13),
			"position" = Vector2(12,20),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0
		},
		"detect_landing" = {
			"size" = Vector2(28, 1.5),
			"position" = Vector2(0,26),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"detect_side_collision" = {
			"size" = Vector2(34, 46),
			"position" = Vector2(0,-26),
			"rotation" = 0.0,
			"scale" = 1.0,
			"skew" = 0.0,
		},
		"main_engine" = {
			"position" = Vector2(0,47),
			"rotation" = 180.0,
			"scale" = 0.4,
			"skew" = 0
		},
		"left_thruster" = {
			"position" = Vector2(-23, -4),
			"rotation" = -90.0,
			"scale" = 0.2,
			"skew" = 0
		},
		"right_thruster" = {
			"position" = Vector2(23, -4),
			"rotation" = 90.0,
			"scale" = 0.2,
			"skew" = 0
		},
	},}
