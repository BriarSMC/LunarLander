extends Polygon2D


# Thx to https://github.com/KoBeWi
# https://github.com/godotengine/godot-proposals/issues/1804
func _ready():
	var poly := CollisionPolygon2D.new()
	poly.polygon = polygon
	poly.position = position
	get_parent().call_deferred("add_child", poly)
