extends Node2D

@onready var enemy_scene = preload("res://enemy/enemy.tscn")

func _ready():
	var camera = find_child("Camera2D")
	var min_pos = $CameraLimit_min.global_position
	var max_pos = $CameraLimit_max.global_position
	camera.limit_left = min_pos.x
	camera.limit_top = min_pos.y
	camera.limit_right = max_pos.x
	camera.limit_bottom = max_pos.y
	
	spawn_enemy(Vector2(400, 300)) 

@warning_ignore("shadowed_variable_base_class")
func spawn_enemy(position: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.position = position
	add_child(enemy)


@warning_ignore("unused_parameter")
func _on_area_2d_body_exited(body: Node2D) -> void:
	pass
