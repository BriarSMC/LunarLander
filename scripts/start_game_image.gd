extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_region_rect(get_viewport().get_visible_rect())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
