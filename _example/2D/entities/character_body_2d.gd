extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = lerp(velocity, direction * SPEED, delta*10)
	else:
		velocity = lerp(velocity, Vector2.ZERO, delta*10)

	move_and_slide()
