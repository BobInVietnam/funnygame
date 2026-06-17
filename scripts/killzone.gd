extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Princess"):
		get_tree().reload_current_scene()
	else:
		if body.has_method("get_hurt"):
			body.get_hurt(99999)
