extends Node3D

var animation_player
var animation_name

func _ready() -> void:
	animation_player = get_node("AnimationPlayer")
	animation_name = get_meta("doorOpen")

func _door_interact_receiver() -> void:
	print("door interact reciever")
	if animation_player == null:
		return
	animation_player.play(animation_name)

func _process(_delta: float) -> void:
	pass
