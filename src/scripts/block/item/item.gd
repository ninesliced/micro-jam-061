extends Resource
class_name Item

@export var name: String
@export var texture: Texture2D

var current_state = 0
var water_level = 0
@export var random_state_update: float = 0.2
@export var max_random_state = 4

@export var tileset_source_id = 0
@export var tileset_atlas_coord = Vector2i(0, 0)
