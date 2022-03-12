extends Actor


#onready var stomp_area: Area2D = $StompArea2D





func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x


func _physics_process(delta: float) -> void:
	var snap: = Vector2.DOWN * 65.0
	_velocity.y = move_and_slide_with_snap(_velocity, snap, FLOOR_NORMAL).y
	_velocity.x *= -1 if is_on_wall() else 1


func die() -> void:
	queue_free()

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	print("enemy stomp")
	if body.global_position.y > get_node("StompDetector").global_position.y:
		print("invalid stomp")
		return
	print("dead")
	die()
