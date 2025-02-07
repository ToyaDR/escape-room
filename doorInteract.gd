extends StaticBody3D

signal door_interact
var update_inventory = false

func interact() -> void:
	print("door hit")
	door_interact.emit()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
