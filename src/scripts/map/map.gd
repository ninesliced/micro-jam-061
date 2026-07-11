extends Node2D
class_name Map

static var element_type: Dictionary[String, Element] = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Grasse" = load("res://src/scripts/block/element/grasse.tres")
}


static var item_type: Dictionary[String, Item] = {
	"Seed" = load("res://src/scripts/block/item/seed.tres"),
	"Tree" = load("res://src/scripts/block/item/seed.tres"),
	"Barrier" = load("res://src/scripts/block/item/seed.tres")
}


var map: Dictionary[Vector2i, Block] = {}

@onready var item_layer: TileMapLayer = $ItemLayer
@onready var element_layer: TileMapLayer = $ElementLayer

func _ready() -> void:
	place_element(Vector2i(0,0), element_type["Sand"])


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

# Retourne true si ca a reussi a interact
func interact_at(pos: Vector2i, picakble: Pickable) -> bool:
	# print(picakble.type, " ", Pickable.PickableType.Sand)
	# Place element
	if is_element_placable(pos) and picakble:
		match picakble.type:
			Pickable.PickableType.Sand:
				place_element(pos, element_type["Sand"])
				return true
				
	# Place item
	var current_block = get_current_block(pos)
	# Si y'a un block et que il que y'a pas d'item dessus
	if current_block != null and current_block.item != null:
		match picakble:
			Pickable.PickableType.Seed:
				place_item(pos, item_type["Seed"])
				return true
			Pickable.PickableType.Wood:
				place_item(pos, item_type["Wood"])
				return true
	return false


func place_element(pos: Vector2i, element: Element):
	self.map[pos] = Block.new(pos, self, element)
	a_block_was_updated(pos, self.map[pos])

func delete_block(pos: Vector2i):
	self.map.erase(pos)
	a_block_was_updated(pos, null)
	
func place_item(pos: Vector2i, item: Item):
	self.map[pos].item = item
	a_block_was_updated(pos, self.map[pos])

func destroy_block(pos: Vector2i):
	delete_block(pos)
	a_block_was_updated(pos, null)

func a_block_was_updated(pos: Vector2i, block: Block):
	element_layer.block_updated(pos, block)
	#item_layer.block_updated(block)


func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var pressed = (
			(event is InputEventMouseButton and event.is_pressed()) or 
			(event is InputEventMouseMotion and 
				(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or 
				Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))
			)
		)
		
		if pressed:
			var pos = item_layer.to_local(get_global_mouse_position())
			var grid_pos = item_layer.local_to_map(pos)
			
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var game = $".."
				var pickable = game.get_hand()
				print(grid_pos)
				var interact_has_worked = interact_at(grid_pos, pickable)
				if interact_has_worked:
					game.use_hand()
					
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
				destroy_block(grid_pos)
