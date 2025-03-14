extends Node3D

var door
func _ready():
	door = get_child(0);

func _on_player_carrying_object():
	door.set_freeze_enabled(true)

func _on_player_not_carrying_object():
	door.set_freeze_enabled(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
