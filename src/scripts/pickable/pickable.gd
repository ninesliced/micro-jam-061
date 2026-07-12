extends Resource
class_name Pickable

enum PickableType {
	Seed, Sand, Water, Wood, George
}

@export var sprite : Texture2D
@export var type: PickableType
@export var audio: AudioStream
