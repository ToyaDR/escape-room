extends Node

var timer = 0

func _process(_delta):
	timer += 1
	if (timer > 100):
		get_tree().change_scene_to_file('res://the-room.tscn')