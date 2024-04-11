class_name Fuelcell
extends Sprite2D


# Just rotate it
func _process(delta):
	rotation += delta * 0.5


func _on_area_2d_body_entered(body):
	get_node(Constant.Lander).emit_signal("refuel_requested", 200.0)
	queue_free()
