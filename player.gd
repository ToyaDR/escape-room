extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var interact_raycast

var vertical_pivot

var look_speed = 0.001
var rotation_x = 0.0
var rotation_y = 0.0

var carried_object
var hand

var default_inventory = {
  "game_console": false,
  "calculator": false,
  "headphones": false,
  "paint": false,
  "how_to_draw_books": false,
  "old_clothes": false,
}
var inventory

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	interact_raycast = get_node('player-vision/vertical-pivot/RayCast3D')
	vertical_pivot = get_node('player-vision/vertical-pivot')
	hand = get_node('player-vision/vertical-pivot/Marker3D')
	inventory = default_inventory

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
		vertical_pivot.rotate_object_local(Vector3.LEFT, clamped_y)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("interact"):
		var just_interacted = false

		var interact = interact_raycast.get_collider()
		if interact != null:
			just_interacted = true
			if interact.has_method("interact"):
				interact.interact()
				if (interact.update_inventory):
					inventory[interact.item_name] = true
			elif (interact is RigidBody3D):
				if (carried_object == null):
					carried_object = interact
				else:
					carried_object = null
		
		# the object sometimes lags behind the cursor and this makes it so the 
		# raycast is not actually colliding with a rigid body. So regardless of
		# collision or not, we should let go of any object being carried
		if (carried_object != null && !just_interacted):
			carried_object = null
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if (carried_object):
		carried_object.set_linear_velocity(SPEED * (hand.global_transform.origin - carried_object.global_transform.origin))
