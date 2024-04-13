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
