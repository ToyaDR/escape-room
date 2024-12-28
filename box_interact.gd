extends StaticBody3D

signal box_interact
func interact() -> void:
	print("box hit")
	box_interact.emit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
