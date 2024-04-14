extends Node2D

@onready var engine_player: AudioStreamPlayer = $EnginePlayer
@onready var thruster_player: AudioStreamPlayer = $ThrusterPlayer
@onready var explosion_player: AudioStreamPlayer = $ExplosionPlayer
@onready var start_screen_player: AudioStreamPlayer = $StartScreenPlayer
@onready var play_level_player: AudioStreamPlayer = $PlayLevelPlayer

func engine(on_off: bool) -> void:
	if on_off:
		if not engine_player.is_playing(): 
			engine_player.play()
	else:
		engine_player.stop()
		
		
func thruster(on_off: bool) -> void:
	if on_off:
		if not thruster_player.is_playing(): 
			thruster_player.play()
	else:
		thruster_player.stop()

func explosion() -> void:
	explosion_player.play()

func start_screen_music(on_off: bool = true) -> void:
	if on_off:
		if not start_screen_player.is_playing():
			start_screen_player.play()
	else:
		start_screen_player.stop()
		
func play_level_music(on_off: bool = true) -> void:
	if on_off:
		if not play_level_player.is_playing():
			play_level_player.play()
	else:
		play_level_player.stop()
