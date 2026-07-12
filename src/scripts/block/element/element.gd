extends Node
class_name Element

var element_name: String
var texture: Texture2D
var terrain_set: int = 0
var terrain: int = 0
var tile_map_layer: String = "ElementLayer"

var erosion_level = 0
var erosion_proba: float = -1
var erosion_max = 15

@export var element_resource: ElementResource

func get_value_letter():
	return self.element_name[0] + str(erosion_level)

func _init(element_resource_: ElementResource) -> void:
	self.element_name = element_resource_.name
	self.texture = element_resource_.texture
	self.terrain_set = element_resource_.terrain_set
	self.terrain = element_resource_.terrain
	self.tile_map_layer = element_resource_.tile_map_layer
	erosion_level = element_resource_.erosion_level
	self.erosion_proba = element_resource_.erosion_proba
	self.erosion_max = element_resource_.erosion_max
	element_resource = element_resource_
	
