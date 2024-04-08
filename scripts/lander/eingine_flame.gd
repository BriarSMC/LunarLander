class_name EngineFlame
extends Node2D

#region Description
# Control the flame animation and sounds for the engines.
#
# This module exists for the sole purpose of moving the code out of the lander
# node to make it more readable. Screw using signals to communicate with the parent.
# So we use pointers to the Lander  to facilitate calling the 
# necessary functions in it.
#endregion


#region signals, enums, constants, variables, and such

# signals

# enums

# constants

# exports (The following properties must be set in the Inspector by the designer)

@export var lander: Lander

# public variables

# private variables

# onready variables

#endregion


# Virtual Godot methods


# Built-in Signal Callbacks


# Custom Signal Callbacks


# Public Methods

# engine_flame(engine, on_off = false)
# Start or stop the main engine/thruster animation based on on_off
#
# Parameters
#	engine: int						0 = Main, 1 = Left thruster, 2 = Right thruster, 3 = All engines
#	show: bool						True: Show engine, False: Don't show engine
# Return
#	None
#==
# Start/Stop the appropriate engine
# If ALL, then all engines are stopped regardless of show
func throttle(engine: int, on_off: bool = false) -> void:
	match engine:
		Constant.selected_engine.MAIN, \
		Constant.selected_engine.LEFT, \
		Constant.selected_engine.RIGHT:
			if on_off:
				lander.engines[engine].play("engine_on")
				lander.engines[engine].visible = true
			else:
				lander.engines[engine].stop()
				lander.engines[engine].visible = false
			
	match engine:			
		Constant.selected_engine.MAIN:
			Audioplayer.engine(on_off)
			
		Constant.selected_engine.LEFT, Constant.selected_engine.RIGHT:
			Audioplayer.thruster(on_off)
			
	match engine:			
		Constant.selected_engine.ALL:
			for e in lander.engines:
				e.visible = false
				e.stop()
			Audioplayer.engine(false)
			Audioplayer.thruster(false)
				
				

# Private Methods


# Subclasses

