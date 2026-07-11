extends Node2D
class_name Map

const ressources = {
	Block.Element.SAND = load("res://src/scripts/block/element/sand.tres")
}

var map: Dictionary[Vector2i, Block] = {
	Vector2i(0,0): Block.new(Block.Element.SAND, Block.Item.VOID)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
