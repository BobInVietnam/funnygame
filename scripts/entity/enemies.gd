class_name Enemy
extends CharacterBody2D

@export var health: int = 100
@export var speed: float = 100.0
@export var contact_damage: int = 10
var current_health: int

func _ready() -> void:
	current_health = health

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
