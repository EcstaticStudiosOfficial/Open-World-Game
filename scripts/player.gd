extends CharacterBody3D

# dictionary
# imp -- impulse
# vel -- velocity
# mag -- magnitude
# sens -- sensitivity
# dir -- direction

@onready var yaw: Node3D = $yaw
@onready var pitch: Node3D = $yaw/pitch

var input_dir: Vector2 = Vector2.ZERO
var motion_dir: Vector3 = Vector3.ZERO
var jump_imp: float = 20.0
var walk_vel: float = 9.0
var gravity: float = 4.8
var yaw_mag: float = 0.0
var pitch_mag: float = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw_mag = -event.relative.x
		pitch_mag = -event.relative.y

func _process(delta: float) -> void:
	print(yaw_mag)
	print(pitch_mag)
	if InputEventMouseMotion:
		yaw_mag = 0.0
		pitch_mag = 0.0
	yaw.rotate_y(yaw_mag * delta)
	pitch.rotate_x(pitch_mag * delta)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity
	input_dir = Input.get_vector("left", "right", "backward", "forward")
	motion_dir = Vector3(input_dir.x, 0.0, input_dir.y)
	velocity = motion_dir
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_imp
	move_and_slide()
