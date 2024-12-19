extends Node3D

signal door_interact

func door_interact_emitter() -> void:
	door_interact.emit()

func door_interact_receiver() -> void:
	var animation_name = get_meta("doorToggle")
	var animation_player = get_node("AnimationPlayer")
	animation_player.play(animation_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
