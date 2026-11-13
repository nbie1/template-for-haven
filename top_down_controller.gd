class_name TopDownMovementComponent

extends Node2D

## A top-down movement component, can be attached to a [code]CharacterBody2D[/code].
## Note that you have to map the inputs for "left", "right", "up" and "down"

@export_category("Movement")
## The [code]CharacterBody2D[/code] that has top-down movement
@export var player: CharacterBody2D
## The speed of the player go from 0 to max velocity
@export var acceleration: float = 50.0
## The highest velocity the player could get
@export var max_velocity: float = 300.0
## The speed of the player go from max velocity to 0
@export var deceleration: float = 80.0
## The speed of the player go from a direction to a opposite direction. Set to 0 to disable brake
@export var brake: float = 150.0
## Determine the behaviour when it collides with another body
@export_enum("Collide", "Slide") var on_collision: String


@onready var current_velocity: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var input_direction: Vector2 = Vector2(0, 0) #= Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("left"):
		input_direction.x -= 1;
	if Input.is_action_pressed("right"):
		input_direction.x += 1;
	if Input.is_action_pressed("up"):
		input_direction.y -= 1;
	if Input.is_action_pressed("down"):
		input_direction.y += 1;
	input_direction = input_direction.normalized()
		
	
	if input_direction == Vector2(0, 0):
		current_velocity = max(0, current_velocity - deceleration)
		player.velocity = player.velocity.normalized() * current_velocity
	elif player.velocity.dot(input_direction) < 0 and brake != 0:
		current_velocity = max(0, current_velocity - brake)
		player.velocity = player.velocity.normalized() * current_velocity
	else:
		current_velocity = min(max_velocity, current_velocity + acceleration)
		player.velocity = input_direction * current_velocity
	
	var collision: KinematicCollision2D = player.move_and_collide(player.velocity * delta)
	if collision:
		if on_collision == "Slide":
			player.velocity = player.velocity.slide(collision.get_normal())
