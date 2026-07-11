extends Node2D
class_name Map

var element_type = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Dirt" = load("res://src/scripts/block/element/dirt.tres")
}


var item_type = {
	"Seed" = load("res://src/scripts/block/element/sand.tres"),
	"Tree" = load("res://src/scripts/block/element/dirt.tres"),
	"Barrier" = load("res://src/scripts/block/element/dirt.tres")
}


var map: Dictionary[Vector2i, Block] = {
	Vector2i(0,0): Block.new(element_type["Sand"], null)
}

@onready var item_layer: TileMapLayer = $ItemLayer
@onready var element_layer: TileMapLayer = $ElementLayer


func is_element_placable(pos: Vector2i):
	# Place item
	if pos in map.keys():
		return false
	# faut check si a touche une case a cote
	for dpos in Utils.four_directions:
		if pos+dpos in map.keys():
			return true
	return false

func get_current_block(pos: Vector2i) -> Block: # Ou null
	if pos in map.keys():
		return map[pos]
	return null

func interact_at(pos: Vector2i, picakble: Pickable):
	# Place element
	if is_element_placable(pos):
		match picakble:
			Pickable.pickableType.Sand:
				place_item(pos, element_type["Sand"])
				return
				
	# Place item
	var current_block = get_current_block(pos)
	# Si y'a un block et que il que y'a pas d'item dessus
	if current_block != null and current_block.item != null:
		match picakble:
			Pickable.pickableType.Seed:
				place_item(pos, element_type["Seed"])
				return
			Pickable.pickableType.Wood:
				place_item(pos, element_type["Wood"])
				return
	return
	
func place_element(pos: Vector2i, element: Element):
	self.map[pos] = Block.new(element)
	element_layer.set_cells_terrain_connect([pos], element.terrain_set, element.terrain)


func place_item(pos: Vector2i, item: Item):
	self.map[pos].item = item
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_visuals_element(cell: Vector2i, element: Element, layer: TileMapLayer = element_layer):
	layer.set_cells_terrain_connect([cell], element.terrain_set, element.terrain)
