extends RigidBody2D

func _on_detect_landing_body_entered(body):
	get_parent().emit_signal("landing_sensed", body)


func _on_detect_side_contact_body_entered(body):
	get_parent().emit_signal("crash_sensed", body)
