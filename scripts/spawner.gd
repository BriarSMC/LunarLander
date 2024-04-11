class_name Spawner
extends Node2D



#region Description
# <description>
#endregion


#region signals, enums, constants, variables, and such

# signals

signal spawn_fuelcell_requested (pos: Vector2)

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

# public variables

# private variables

@export var spawned_items:Node2D

# onready variables

@onready var fuelcell_scene := preload("res://scenes/collectables/fuelcell.tscn")

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
# What the code is doing (steps)
# NOTE: Child must call super._ready() if it defines own _ready() method
func _ready() -> void:
	spawn_fuelcell_requested.connect(spawn_fuelcell)
	


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
func _process(delta) -> void:
	pass

# Built-in Signal Callbacks


# Custom Signal Callbacks

func spawn_fuelcell(pos: Vector2) -> void:
	var fuelcell =fuelcell_scene.instantiate()
	var newx := randf_range(300.0, 500.0) * float(sign(randi_range(-1, 1)))
	fuelcell.position = Vector2(pos.x + newx, pos.y)
	spawned_items.add_child(fuelcell)

# Public Methods


# Private Methods


# Subclasses

