extends Enemy
class_name FlyingBot

enum BotState {IDLE, ATTACK}
@onready var animated_sprite = $AnimatedSprite2D
var state: BotState = BotState.IDLE
var player: Node2D = null
var direction: int = 1

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Princess")
	if players.size() > 0:
		player = players[0]
	current_health = health

func _physics_process(delta: float) -> void:
	if direction == 1:
		animated_sprite.flip_h = true
	elif direction == -1:
		animated_sprite.flip_h = false
		
	match state:
		BotState.IDLE:
			velocity = Vector2.ZERO
		BotState.ATTACK:
			move_towards_player(delta)
	move_and_slide()
			
func move_towards_player(delta: float) -> void:
	# Guard clause: Make sure the player actually exists in the scene before tracking
	if player == null:
		return
	# Target position is where the player is located globally
	var target_position: Vector2 = player.global_position
	var direction_vector: Vector2 = (target_position - global_position).normalized()
	if target_position.x > global_position.x:
		direction = 1
	else:
		direction = -1
	
	# Move this Area2D's position towards the target position
	velocity = speed * direction_vector

func get_hurt(damage: int) -> void:
	current_health -= damage
	play_hit_flash()
	if (current_health <= 0):
		queue_free()
		
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

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Princess"):
		body.get_hurt(contact_damage)

func _on_detection_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Princess"):
		state = BotState.ATTACK


func _on_detection_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("Princess"):
		state = BotState.IDLE
