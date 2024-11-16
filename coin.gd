class_name coin extends Area2D

const force = -400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func destroy()-> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:

	destroy()
	pass # Replace with function body.
