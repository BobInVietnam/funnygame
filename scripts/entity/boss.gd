extends Enemy
class_name Boss

signal hurt(current_health: int)
signal enter_combat()
signal down()

@export var projectile: PackedScene
@export var slash: PackedScene
@export var bot_scene: PackedScene

enum State {IDLE, CHASE, SPAWN_ENEMIES, DASH, DOWN}
@onready var animated_sprite = $AnimatedSprite2D
@onready var bot_spawnpoint = $BotSpawn
@onready var bot_spawnpoint2 = $BotSpawn2
@onready var cooldown = $AtkCooldown
var current_state = State.IDLE
var ready_to_spawn = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if current_state == State.SPAWN_ENEMIES and ready_to_spawn:
		spawn_minion()
	move_and_slide()
	
func spawn_minion() -> void:
	ready_to_spawn = false
	cooldown.start(6.0)
	var bot_instance = bot_scene.instantiate() as FlyingBot
	if randf() >= 0.5:
		bot_instance.global_position = bot_spawnpoint.global_position
	else:
		bot_instance.global_position = bot_spawnpoint2.global_position
	get_tree().current_scene.add_child(bot_instance)

func get_hurt(damage: int) -> void:
	current_health -= damage
	hurt.emit(current_health)
	play_hit_flash()
	if (current_health <= 0):
		animated_sprite.play("down")
		current_state = State.DOWN
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
		current_state = State.SPAWN_ENEMIES
		enter_combat.emit()


func _on_atk_cooldown_timeout() -> void:
	ready_to_spawn = true
