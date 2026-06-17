extends Enemy
class_name BossIdle

@onready var animated_sprite = $AnimatedSprite2D

func get_hurt(damage: int) -> void:
	current_health -= damage
	play_hit_flash()
	if (current_health <= 0):
		animated_sprite.play("down")
		
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
