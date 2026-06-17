extends CharacterBody2D

enum AmmoType {RED, YELLOW, BLUE}
enum PlayerState {NORMAL, HURT, DOWN}

@export var speed: float = 200.0
@export var maxHealth: int = 100
@export var jumpVelocity: float = -200.0
@export var red_proj_scene: PackedScene
@export var yellow_proj_scene: PackedScene
@export var blue_proj_scene: PackedScene

@onready var animatedSprite = $AnimatedSprite2D
@onready var invin_timer = $InvinTimer
@onready var cooldown_timer = $CooldownsTimer
@onready var muzzle = $Muzzle

const COOLDOWN = 0.5
var currentHealth: int
var currentState: PlayerState = PlayerState.NORMAL
var currentAmmoType: AmmoType = AmmoType.YELLOW
var ready_to_shoot: bool = true
var shootCooldown: float = 0.0
var invincible: bool = false

func _ready() -> void:
	currentHealth = maxHealth

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jumpVelocity

	# Handle shooting
	if Input.is_action_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("projectile_1"):
		currentAmmoType = AmmoType.RED
		print("Ammo: Strong Red")
	if Input.is_action_just_pressed("projectile_2"):
		currentAmmoType = AmmoType.YELLOW
		print("Ammo: Versatile Yellow")
	if Input.is_action_just_pressed("projectile_3"):
		currentAmmoType = AmmoType.BLUE
		print("Ammo: Rapid Blue")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	play_animation()

func play_animation() -> void:
	match currentState:
		PlayerState.DOWN:
			animatedSprite.play("hurt")
		PlayerState.HURT:
			animatedSprite.play("hurt")
		PlayerState.NORMAL:
			var direction := Input.get_axis("move_left", "move_right")
			if direction > 0:
				animatedSprite.flip_h = false
			elif direction < 0:
				animatedSprite.flip_h = true
			if !is_on_floor():
				if Input.is_action_pressed("shoot"):
					animatedSprite.play("atk")
				else:
					animatedSprite.play("jump")
				return
				
			if direction:
				if Input.is_action_pressed("shoot"):
					animatedSprite.play("run_atk")
				else:
					animatedSprite.play("run")
			else:
				if Input.is_action_pressed("shoot"):
					animatedSprite.play("atk")
				else:
					animatedSprite.play("default")
	
func shoot() -> void:
	if (!ready_to_shoot):
		return
		
	ready_to_shoot = false
	var mouse_pos = get_global_mouse_position()
	var shoot_dir = muzzle.global_position.direction_to(mouse_pos)
	var projectile_instance
	
	match currentAmmoType:
		AmmoType.RED:
			if red_proj_scene:
				projectile_instance = red_proj_scene.instantiate() as Projectile
			else:
				print("Missing red_projectile_scene asset in Inspector!")
		AmmoType.YELLOW:
			if yellow_proj_scene:
				projectile_instance = yellow_proj_scene.instantiate() as Projectile
			else:
				print("Missing yellow_projectile_scene asset in Inspector!")
		AmmoType.BLUE:
			if blue_proj_scene:
				projectile_instance = blue_proj_scene.instantiate() as Projectile
			else:
				print("Missing blue_projectile_scene asset in Inspector!")
				
	cooldown_timer.start(projectile_instance.cooldown)
	projectile_instance.global_position = muzzle.global_position
	projectile_instance.direction = shoot_dir
	projectile_instance.rotation = shoot_dir.angle()
	get_tree().current_scene.add_child(projectile_instance)


func get_hurt(damage: int) -> void:
	if (invincible):
		return
	
	currentHealth -= damage
	currentState = PlayerState.HURT
	invin_timer.start()
	invincible = true
	if (currentHealth <= 0):
		currentState = PlayerState.DOWN
		
	play_hit_flash()

func play_hit_flash() -> void:
	# Fetch the shader material attached to our sprite
	var shader_material = animatedSprite.material as ShaderMaterial
	
	if shader_material:
		# Create a quick animation sequence
		var tween = create_tween()
		# Turn the sprite completely white instantly (0.0 seconds)
		tween.tween_property(shader_material, "shader_parameter/flash_modifier", 1.0, 0.0)
		# Fade back to normal over 0.15 seconds
		tween.tween_property(shader_material, "shader_parameter/flash_modifier", 0.0, 0.15)

func _on_invin_timer_timeout() -> void:
	currentState = PlayerState.NORMAL
	invincible = false


func _on_cooldowns_timer_timeout() -> void:
	ready_to_shoot = true
