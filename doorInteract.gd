extends RigidBody3D

signal door_interact
var door_opener: Marker3D

var update_inventory = false
func interact() -> void:
	var door_opener_position = door_opener.transform.origin;
	var door_opener_impulse = Vector3(0, 0, 2.0)
	# print("\n\nPOSITION: ("
	# + str(door_opener_position.x) + ","
	# + str(door_opener_position.y) + ","
	# + str(door_opener_position.z) + ") \nFORCE: ("
	# + str(door_opener_impulse.x) + ","
	# + str(door_opener_impulse.y) + ","
	# + str(door_opener_impulse.z) + ")");
	apply_impulse(door_opener_impulse, door_opener_position);

func _ready() -> void:
	door_opener = get_node("opener");
	pass

func _process(_delta: float) -> void:
	pass
