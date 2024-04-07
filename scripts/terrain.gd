class_name Terrain
extends StaticBody2D


#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var max_terrain_width := 8.0
@export var min_segment_length := 30.0
@export var max_segment_length := 120.0
@export var min_segment_height := 30.0
@export var max_segment_height := 200.0

# public variables

# private variables

# onready variables

@onready var poly := $Poly
@onready var coll := $CollisionPolygon2D
@onready var screen_height: float = get_viewport().content_scale_size.y
@onready var terrain_width: float = get_viewport().content_scale_size.x * max_terrain_width

#endregion


# Virtual Godot methods

# _ready()
# Called when node is ready
#
# Parameters
#		None
# Return
#		None
#==
# Thx to https://github.com/KoBeWi
# https://github.com/godotengine/godot-proposals/issues/1804
func _ready() -> void:
	poly.polygon = generate_points()
	coll.polygon = poly.polygon
	coll.position = position
	
	#printt("Width/Height: ", terrain_width, screen_height)



# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float            	Seconds elapsed since last frame
# Return
#	None
#==
# What the code is doing (steps)
# NOTE: Child must call super._ready() if it defines own _ready() method
func _process(delta) ->void:
	pass


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

func get_terrain_width() -> float:
	return terrain_width
	
	
# Private Methods

func generate_points() -> Array[Vector2]:
	var arr: Array[Vector2]
	var loc := - terrain_width / 2.0
	var height: float
	
	#print("First loc: ", loc)
	height = randf_range(min_segment_height, max_segment_height)
	arr.append(Vector2(loc, screen_height - height))
	
	while loc <= terrain_width / 2.0:		
		if randf_range(0.0, 1.0) > 0.333:
			height = randf_range(min_segment_height, max_segment_height)
		loc += randf_range(min_segment_length, max_segment_length)
		arr.append(Vector2(loc, screen_height - height))
	
	arr.append(Vector2(loc, 5000))
	arr.append(Vector2(-terrain_width / 2.0, 5000))
	
	return arr
	

# Subclasses

