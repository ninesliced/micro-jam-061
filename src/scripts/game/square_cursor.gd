extends Sprite2D
@onready var map: Map = %Map
@onready var game: Game = $".."

func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	var tilemap = map.element_layer
	var map_pos = tilemap.local_to_map(tilemap.to_local(mouse))
	var interactible = is_interactible(map_pos, game.hand)
	
	if interactible:
		global_position = Vector2(map_pos * 16.0)
		show()
	else:
		hide()
		


func is_interactible(pos: Vector2i, picakble: Pickable) -> bool:
	if map.is_element_placable(pos) and picakble:
		match picakble.type:
			Pickable.PickableType.Sand:
				return true
				
	var current_block = map.get_current_block(pos)
	if current_block != null and current_block.item == null and picakble:
		match picakble.type:
			Pickable.PickableType.Seed:
				return true
	
	# Reparer le sable
	if current_block and current_block.element.element_name == "Sand" and picakble and picakble.type == Pickable.PickableType.Sand:
		return true
	return false
