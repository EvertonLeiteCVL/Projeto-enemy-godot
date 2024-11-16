class_name Enemy
extends CharacterBody2D

const States = {
	IDLE = "idle",
	WALK = "walk",
	RUN = "run",
}

const WALK_SPEED = 100.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0

var health: int = 100
var attack_damage: int = 10

@onready var sprite: Sprite2D = $Sprite2D
@onready var floor_detector_left: RayCast2D = $FloorDetectorLeft
@onready var floor_detector_right: RayCast2D = $FloorDetectorRight
@onready var platform_detector: RayCast2D = $PlatformDetector

func _ready():
	add_to_group("enemies")
	floor_detector_left.enabled = true
	floor_detector_right.enabled = true
	platform_detector.enabled = true

func receive_damage(damage: int):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

func _physics_process(delta: float) -> void:
	var player = get_node("/root/YourMainScene/Player")

	if player:
		var direction = (player.position - position).normalized()
		velocity = velocity.move_toward(direction * WALK_SPEED, ACCELERATION_SPEED * delta)

		move_and_slide()

		if velocity.length() > 0:
			sprite.scale.x = sign(velocity.x)
			$AnimationTree["parameters/state/transition_request"] = States.RUN
		else:
			$AnimationTree["parameters/state/transition_request"] = States.IDLE

		if position.distance_to(player.position) < 50:
			attack_player(player)

		if floor_detector_left.is_colliding():
			pass
			
		if floor_detector_right.is_colliding():
			pass
			
		if platform_detector.is_colliding():
			pass

func attack_player(player):
	player.receive_damage(attack_damage)
