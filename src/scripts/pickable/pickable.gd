extends Resource
class_name Pickable

enum pickableType {
	Seed, Sand, Water, Wood
}

@export var sprite : Texture2D
@export var type: pickableType
