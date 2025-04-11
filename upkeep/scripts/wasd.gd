extends CharacterBody2D

const SPEED = 100.0
const PUSH_FORCE = 200.0
var pressed = false
var released = true

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("move_a", "move_d"),
		Input.get_axis("move_w", "move_s")
	).normalized()
	var pos = get_position_delta()
	#print(position)
	velocity = input_vector * SPEED
	
	move_and_collide(velocity * delta)
	
	if Input.is_action_just_pressed("WASD_carry"):
		pressed = true
		released = false
		carry()

func carry():
	pass
