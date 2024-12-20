extends Node3D

func _door_interact_receiver() -> void:
	print("door interact reciever")
	var animation_name = get_meta("doorOpen")
	var animation_player = get_node("AnimationPlayer")
	animation_player.play(animation_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
