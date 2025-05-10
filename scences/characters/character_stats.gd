class_name CharacterStats
extends Resource

# Movement
@export var base_speed := 150.0
@export var top_speed := 300.0
@export_range(0, 1) var acceleration := 0.1
@export_range(0, 1) var deceleration := 0.1
@export var jump_force := 350.0
@export_range(0, 1) var jump_deceleration := 0.5
@export var gravity := 980.0
@export var gravity_vector := Vector2.DOWN

# Imput
@export var left : StringName
@export var up : StringName
@export var right : StringName

# Animations
@export var idle := &"idle"
@export var jumping := &"jumping"
@export var walking := &"walking"
