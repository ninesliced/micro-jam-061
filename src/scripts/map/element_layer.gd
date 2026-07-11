extends TileMapLayer

func block_updated(position: Vector2i, block: Block):
	if block and block.element:
		set_cells_terrain_connect([block.position], block.element.terrain_set, block.element.terrain)
	else:
		set_cells_terrain_connect([position], 0, -1)
