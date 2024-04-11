extends Node

var lander_type := 0


@export var difficulty = {
	"EASY" = {
		"MAXV" = 400.0,
		"MAXH" = 100.0,
		"FUEL" = 1000.0,
	},
	"MEDIUM" = {
		"MAXV" = 300.0,
		"MAXH" = 75.0,
		"FUEL" = 500.0,
	},
	"HARD" = {
		"MAXV" = 200.0,
		"MAXH" = 50.0,
		"FUEL" = 300.0,
	},
}
var level := "EASY"
