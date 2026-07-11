extends Node2D
class_name Map

var elementType = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Dirt" = load("res://src/scripts/block/element/dirt.tres")
}


var itemType = {
	"Seed" = load("res://src/scripts/block/element/sand.tres"),
	"Tree" = load("res://src/scripts/block/element/dirt.tres"),
	"Barrier" = load("res://src/scripts/block/element/dirt.tres")
}


var map: Dictionary[Vector2i, Block] = {
	Vector2i(0,0): Block.new(elementType["Sand"], null)
}

func is_element_placable(pos) -> bool:
	# Un element est deja place, docn non
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
				place_item(pos, elementType["Sand"])
				return
				
	# Place item
	var current_block = get_current_block(pos)
	if current_block != null:
		if current_block.item != null:
			place_item(pos, elementType["Seed"])
		
		
	return

func place_item(pos: Vector2i, item: Item):
	return
	
func place_element(pos: Vector2i, element: Element):
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
