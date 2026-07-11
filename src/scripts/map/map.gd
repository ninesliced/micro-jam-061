extends Node2D
class_name Map

var elementType = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Dirt" = load("res://src/scripts/block/element/dirt.tres")
}


var itemType = {
	"AH" = load("res://src/scripts/block/element/sand.tres"),
	"Dirt" = load("res://src/scripts/block/element/dirt.tres")
}


var map: Dictionary[Vector2i, Block] = {
	Vector2i(0,0): Block.new(elementType["Sand"], null)
}

@onready var item_layer: TileMapLayer = $ItemLayer
@onready var element_layer: TileMapLayer = $ElementLayer


func interact_at(pos: Vector2i, picakble: Pickable):
	# Place item
	if pos in map.keys():
		return
	# Place element
	else: 
		return


func place_item(pos: Vector2i, item: String):
	return


func place_element(pos: Vector2i):
	pass
	#set_cells(pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_visuals_element(cell: Vector2i, element: Element, layer: TileMapLayer = element_layer):
	layer.set_cells_terrain_connect([cell], element.terrain_set, element.terrain)
