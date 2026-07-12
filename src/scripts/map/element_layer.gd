extends TileMapLayer

func block_updated(_position: Vector2i, block: Block):
	if block and block.element and block.element.tile_map_layer == name:
		set_cells_terrain_connect([block.position], block.element.terrain_set, block.element.terrain)
	elif not block:
		set_cells_terrain_connect([_position], 0, -1)
