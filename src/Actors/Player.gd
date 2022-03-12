extends Actor

export var stomp_impulse := 1000.0

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	print("player dead")
	die()


func _on_StompDetector_area_entered(area: Area2D) -> void:
	print("player stomp")
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _physics_process(_delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calculate_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	return Vector2(
		 Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		 -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, 
							direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	var output_velocity := linear_velocity
	
	output_velocity.x = speed.x * direction.x
	output_velocity.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		output_velocity.y = speed.y * direction.y
	
	if is_jump_interrupted:
		output_velocity.y = 0.0
	return output_velocity

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out := linear_velocity
	out.y = -impulse
	return out
	
func die() -> void:
	queue_free()



