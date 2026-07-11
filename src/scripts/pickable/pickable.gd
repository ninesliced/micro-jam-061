extends Resource
class_name Pickable

enum PickableType {
	Seed, Sand, Water, Wood
}

@export var sprite : Texture2D
@export var type: PickableType
