extends Node2D

@onready var engine_player: AudioStreamPlayer = $EnginePlayer
@onready var thruster_player: AudioStreamPlayer = $ThrusterPlayer
@onready var explosion_player: AudioStreamPlayer = $ExplosionPlayer

func engine(on_off: bool) -> void:
	if on_off:
		if not engine_player.is_playing(): 
			print("Engine sound on")
			engine_player.play()
	else:
		engine_player.stop()
		
		
func thruster(on_off: bool) -> void:
	if on_off:
		if not thruster_player.is_playing(): 
			print("Thruster sound on")
			thruster_player.play()
	else:
		thruster_player.stop()

func explosion() -> void:
	explosion_player.play()
