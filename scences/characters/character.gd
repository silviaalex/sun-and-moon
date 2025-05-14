extends CharacterBody2D

@export var stats : CharacterStats
@export var animated_sprite: AnimatedSprite2D
@export var character_name: String
@export var game_node: Node = null
var no_lives = 3
@onready var damage_timer: Timer = $Timer

func _ready():
	damage_timer.timeout.connect(take_damage)

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
	move_and_slide()
	
func take_damage() -> void:
	if no_lives > 1:
		var heart = "Heart" + character_name + str(no_lives)
		no_lives -= 1
		game_node.hearts.get_node(heart).visible = false;
	else:
		game_node.levels.get_node("Level").get_node("LoseState").visible = true
	
func get_damaged() -> void:
	damage_timer.start()
	
func get_damaged_no_longer() -> void:
	damage_timer.stop()
