extends CharacterBody2D

@export var stats : CharacterStats
@export var animated_sprite: AnimatedSprite2D
var is_alive: bool = true

func _ready() -> void:
	SignalBus.level_finished.connect(_on_character_freeze)
	SignalBus.game_over.connect(_on_character_freeze)

func _physics_process(delta: float) -> void:
	# Handle the movement on local gravity vertical axis
	if not is_on_floor():
		# Add gravity
		velocity += stats.gravity * delta * stats.gravity_vector
	elif Input.is_action_just_pressed(stats.up):
		# Perform basic jump
		velocity += -stats.gravity_vector * stats.jump_force
	elif Input.is_action_just_released(stats.up) and velocity.dot(stats.gravity_vector) < 0.0:
		# Perform varaiable jump
		var projection = velocity.project(stats.gravity_vector)
		velocity += projection * (stats.jump_deceleration - 1)
	# Get input direction
	var direction = Input.get_axis(stats.left, stats.right)
	var direction_vector = direction * stats.gravity_vector.orthogonal()
	# Handle the movement on local gravity horizontal axis
	var slide = velocity.slide(stats.gravity_vector)
	if direction:
		# Handle acceleration
		velocity += -slide + slide.move_toward(direction_vector * stats.base_speed, stats.base_speed * stats.acceleration)
	else:
		# Handle deceleration
		velocity += -slide + slide.move_toward(Vector2.ZERO, stats.base_speed * stats.deceleration)
	# Play animations
	if not is_on_floor():
		animated_sprite.play(stats.jumping)
	elif direction == 0:
		animated_sprite.play(stats.idle)
	else:
		animated_sprite.play(stats.walking)
		# Flip sprite towards direction
		if direction > 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	if is_alive:
		move_and_slide()

func _on_character_freeze():
	is_alive = false
