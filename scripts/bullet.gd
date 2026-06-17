extends Projectile
class_name Bullet

@onready var sprite: Sprite2D = $Sprite2D

func move_projectile(delta: float) -> void:
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	position += direction * speed * delta
