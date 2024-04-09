extends CanvasLayer

var start_screen = preload("res://scenes/start_game.tscn")

func _ready():
	$GoBack.grab_focus()
	
func _on_go_back_pressed():
	get_tree().change_scene_to_packed(start_screen)
