extends CharacterBody3D

@onready var yaw: Node3D = $yaw
@onready var pitch: Node3D = $yaw/pitch

var jump_imp: float = 10.0
var walk_vel: float = 9.0
var gravity: float = 20.0
var mouse_sens: float = 0.002

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw.rotate_y(-event.relative.x * mouse_sens)
		pitch.rotate_x(-event.relative.y * mouse_sens)
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	if event.is_action_pressed("ui_cancel"): # Usually 'esc'
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event is InputEventMouseButton and event.pressed:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "backward", "forward")
	# Rotate input direction to be relative to the player's yaw
	var direction = (yaw.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * walk_vel
		velocity.z = direction.z * walk_vel
	else:
		velocity.x = move_toward(velocity.x, 0, walk_vel)
		velocity.z = move_toward(velocity.z, 0, walk_vel)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_imp

	move_and_slide()

