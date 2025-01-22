extends RigidBody3D

var inventory = {
	'calculator': {
		'canvas_path': '/root/the-room/player/CanvasLayer/inventory/calculator',
	}
}

var item_name
var item_ui_node: Sprite2D

var update_inventory = true

func interact() -> void:
	print(item_name + " hit")
	# use item name to get the sprite in the canvas to turn it on
	item_ui_node.visible = true
	queue_free()

func _ready():
	item_name = get_meta('name')
	item_ui_node = get_node(inventory.get(item_name).canvas_path)

func _process(_delta):
	pass
