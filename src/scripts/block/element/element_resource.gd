extends Resource
class_name ElementResource

@export var name: String
@export var texture: Texture2D
@export var terrain_set: int = 0
@export var terrain: int = 0
@export var tile_map_layer: String = "ElementLayer"

var erosion_level = 0
@export var erosion_proba: float = -1
@export var erosion_max = 15

func get_value_letter():
	return name[0] + str(erosion_level)
