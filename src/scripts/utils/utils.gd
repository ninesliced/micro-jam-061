extends Node

var four_directions = [Vector2i(0, 1), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, -1)]

var eight_directions = []
func _ready() -> void:
	for i in range(-1, 2):
		for j in range(-1, 2):
			if i != j:
				eight_directions.append(Vector2i(i,j))

var diagobal_directions = [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]
