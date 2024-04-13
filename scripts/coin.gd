class_name Coin
extends AnimatedSprite2D


func _on_area_2d_body_entered(body):
	get_node(Constant.lander).emit_signal("collect_coin_requested")
	queue_free()
