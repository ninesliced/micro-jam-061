extends Resource
class_name Item

var item_name: String
var texture: Texture2D

var current_state = 0
var water_level = 0
var random_state_update: float = 0.2
var max_random_state = 4

var tileset_source_id = 0
var tileset_atlas_coord = Vector2i(0, 0)


@export var item_resource: ItemResource

func get_value_letter():
	return item_name[0] + str(current_state)

func _init(item_resource_: ItemResource) -> void:
	self.item_name = item_resource_.name
	self.texture = item_resource_.texture
	current_state = item_resource_.current_state
	water_level = item_resource_.water_level
	self.random_state_update = item_resource_.random_state_update
	self.max_random_state = item_resource_.max_random_state
	self.tileset_source_id = item_resource_.tileset_source_id
	self.tileset_atlas_coord = item_resource_.tileset_atlas_coord
	item_resource = item_resource_
