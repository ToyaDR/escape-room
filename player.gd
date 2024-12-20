extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var interact_raycast

var look_speed = 0.001
var rotation_x = 0.0
var rotation_y = 0.0

func _ready() -> void:
	interact_raycast = get_child(1)

func _input(event):
	if (event is InputEventMouseMotion):
		var mouse_motion = event as InputEventMouseMotion
		rotation_x = mouse_motion.relative.x * look_speed
		rotation_y = mouse_motion.relative.y * look_speed
		
		var temp_transform = transform
		transform.basis = Basis.IDENTITY
		transform = temp_transform

		var clamped_y = clamp(rotation_y, deg_to_rad(-90), deg_to_rad(90))

		rotate_object_local(Vector3.UP, rotation_x * -1)
		rotate_object_local(Vector3.LEFT, clamped_y)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("interact"):
		var interact = interact_raycast.get_collider()
		if interact != null:
			if interact.has_method("door_interact_emitter"):
				interact.door_interact_emitter()
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
