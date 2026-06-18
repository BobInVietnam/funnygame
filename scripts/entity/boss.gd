extends Enemy
class_name Boss

signal hurt(current_health: int)
signal enter_combat()
signal down()

@export var projectile: PackedScene
@export var slash: PackedScene

enum State {IDLE, CHASE, SPAWN_ENEMIES, DASH}
@onready var animated_sprite = $AnimatedSprite2D
var current_state = State.IDLE

func get_hurt(damage: int) -> void:
	current_health -= damage
	hurt.emit(current_health)
	play_hit_flash()
	if (current_health <= 0):
		animated_sprite.play("down")
		down.emit()
		
func play_hit_flash() -> void:
	# Fetch the shader material attached to our sprite
	var shader_material = animated_sprite.material as ShaderMaterial
	
	if shader_material:
		# Create a quick animation sequence
		var tween = create_tween()
		# Turn the sprite completely white instantly (0.0 seconds)
		tween.tween_property(shader_material, "shader_parameter/flash_modifier", 1.0, 0.0)
		# Fade back to normal over 0.15 seconds
		tween.tween_property(shader_material, "shader_parameter/flash_modifier", 0.0, 0.15)


func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Princess") and current_state == State.IDLE:
		current_state = State.DASH
		enter_combat.emit()
