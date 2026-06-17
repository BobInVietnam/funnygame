class_name Projectile
extends Area2D

@export var speed: float = 100.0
@export var damage: int = 1
@export var lifetime: float = 10
@export var cooldown: float = 2

var timeElapsed: float = 0
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	# All projectiles move forward by default
	timeElapsed += delta
	if (lifetime < timeElapsed):
		queue_free()
	move_projectile(delta)

func move_projectile(delta: float) -> void:
	position += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_hurt"):
		body.get_hurt(damage)
	_on_impact(body)

# This is a "virtual" function meant to be overridden by child classes
func _on_impact(_body: Node2D) -> void:
	queue_free() # Default behavior: destroy self
