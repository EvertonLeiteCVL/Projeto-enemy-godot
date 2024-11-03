class_name Player
extends CharacterBody2D

const States = {
	IDLE = "idle",
	WALK = "walk",
	RUN = "run",
	FLY = "fly",
	FALL = "fall",
}

const WALK_SPEED = 200.0
const ACCELERATION_SPEED = WALK_SPEED * 6.0
const JUMP_VELOCITY = -400.0
const TERMINAL_VELOCITY = 400

var falling_slow = false
var falling_fast = false
var no_move_horizontal_time = 0.0
var score = 0 

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $Sprite2D
@onready var sprite_scale = sprite.scale.x
@onready var gun = get_node("gun")
@onready var bullet_scene = preload("res://bullet.tscn")  

func launch_player(force: int) -> void:
	velocity.y = force

func _ready():
	add_to_group("player")  
	$AnimationTree.active = true

func collect_coin():
	score += 1
	print("Score: ", score)

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position 
	bullet.rotation = rotation  
	get_parent().add_child(bullet)  

func _physics_process(delta: float) -> void:
	var is_jumping = false
	if Input.is_action_just_pressed("jump"):
		is_jumping = try_jump()
	elif Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.6

	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
	var direction := Input.get_axis("move_left", "move_right") * WALK_SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)

	if no_move_horizontal_time > 0.0:
		velocity.x = 0.0
		no_move_horizontal_time -= delta

	if not is_zero_approx(velocity.x):
		sprite.scale.x = sign(velocity.x) * sprite_scale

	move_and_slide()

	if velocity.y >= TERMINAL_VELOCITY:
		falling_fast = true
		falling_slow = false
	elif velocity.y > 300:
		falling_slow = true

	if is_jumping:
		$AnimationTree["parameters/jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	if is_on_floor():
		if falling_fast:
			$AnimationTree["parameters/land_hard/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			no_move_horizontal_time = 0.4
		elif falling_slow:
			$AnimationTree["parameters/land/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

		if abs(velocity.x) > 50:
			$AnimationTree["parameters/state/transition_request"] = States.RUN
			$AnimationTree["parameters/run_timescale/scale"] = abs(velocity.x) / 60
		elif velocity.x:
			$AnimationTree["parameters/state/transition_request"] = States.WALK
			$AnimationTree["parameters/walk_timescale/scale"] = abs(velocity.x) / 12
		else:
			$AnimationTree["parameters/state/transition_request"] = States.IDLE

		falling_fast = false
		falling_slow = false
	else:
		if velocity.y > 0:
			$AnimationTree["parameters/state/transition_request"] = States.FALL
		else:
			$AnimationTree["parameters/state/transition_request"] = States.FLY

	if Input.is_action_just_pressed("shoot"): 
		shoot()

func try_jump() -> bool:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		return true
	return false
