extends Node3D

var small_box
var medium_box
var large_box

func _ready():
	small_box = load("res://small_box.tscn")
	medium_box = load("res://medium_box.tscn")
	large_box = load("res://large_box.tscn")

	for n in 2:
		var instance: RigidBody3D = large_box.instantiate()
		add_child(instance)
	for n in 3:
		var instance: RigidBody3D = medium_box.instantiate()
		add_child(instance)
	for n in 5:
		var instance: RigidBody3D = small_box.instantiate()
		add_child(instance)

