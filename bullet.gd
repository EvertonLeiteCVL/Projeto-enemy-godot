class_name Bullet
extends RigidBody2D

const SPEED = 600

func _ready() -> void:
	var velocity = Vector2.RIGHT.rotated(rotation) * SPEED
	linear_velocity = velocity

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()
		queue_free()

func _process(delta: float) -> void:
	if position.x < 0 or position.x > get_viewport().size.x:
		queue_free()
