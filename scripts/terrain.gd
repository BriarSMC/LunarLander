class_name Terrain
extends StaticBody2D


#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

signal new_terrain_requested

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var spawner: Spawner

# public variables

# private variables

var rand_gen: RandomNumberGenerator
var generate_terrain := true

# onready variables

@onready var poly := $Poly
@onready var coll := $CollisionPolygon2D
@onready var screen_height: float = get_viewport().content_scale_size.y
@onready var terrain_width: float = get_viewport().content_scale_size.x * Config.max_terrain_width

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
	rand_gen = RandomNumberGenerator.new()
	new_terrain_requested.connect(new_terrain)
	

# _process(delta)
# Called once per frame
#
# Parameters
#	delta: float					Amount of time elapsed since last frame
# Return
#	None
#==
# Ok. So we had _ready() call  new_terrain(). This worked until we added
# coins to the mix. No coins generated. Hmm. Could it be that emitting the 
# signal to spawner wasn't working because spawner hadn't run its _ready() yet?
# Yep. We decided on the quick and dirty instead of adding another layer of 
# signals to generate the coins/terrain/etc.
# Generate the terrain and coins in the first frame and ignore it thereafter.
func _process(_delta):
	if generate_terrain:
		generate_terrain = false
		new_terrain()
	

# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

func get_terrain_width() -> float:
	return terrain_width
	
	
# Private Methods

func new_terrain() -> void:
	rand_gen.randomize()
	
	poly.polygon = generate_points()
	coll.polygon = poly.polygon
	coll.position = position

	
func generate_points() -> Array[Vector2]:
	var arr: Array[Vector2] = []
	var loc := - terrain_width / 2.0
	var height: float
	var segment_length_modifier: float
	var random_modifier: float
	
	
	segment_length_modifier = Config.difficulty[Config.level]["SEGMOD"]
	random_modifier = Config.difficulty[Config.level]["RANMOD"]

		
	height = rand_gen.randf_range(Config.min_segment_height, Config.max_segment_height)
	arr.append(Vector2(loc, screen_height - height))
	
	while loc <= terrain_width / 2.0:		
		if rand_gen.randf_range(0.0, 1.0) > 0.333 * random_modifier:
			height = rand_gen.randf_range(Config.min_segment_height, Config.max_segment_height)
		loc += rand_gen.randf_range(Config.min_segment_length * segment_length_modifier, Config.max_segment_length * segment_length_modifier)
		arr.append(Vector2(loc, screen_height - height))
		generate_coin(arr[-1])
	
	arr.append(Vector2(loc, 5000))
	arr.append(Vector2(-terrain_width / 2.0, 5000))
	
	return arr
	
func generate_coin(pos: Vector2) -> void:
	if rand_gen.randf_range(0.0, 1.0) <= Config.coin_probability:
		var newy: float = pos.y - randf_range(Config.max_segment_height, 500.0)
		#var err = spawner.emit_signal("spawn_coin_requested", Vector2(pos.x, newy))
		var err = spawner.emit_signal("spawn_coin_requested", Vector2(pos.x, newy))
		print("Spawner error: ", err)
	
# Subclasses

