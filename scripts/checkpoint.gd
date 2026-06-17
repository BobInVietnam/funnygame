extends Area2D
class_name Checkpoint

var activated = false;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Princess") and not activated:
		print("Princess checkpointed at ", global_position)
		activated = true
		body.save_checkpoint(global_position + Vector2(0, 10))
