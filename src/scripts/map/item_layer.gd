extends TileMapLayer

func block_updated(position: Vector2i, block: Block):
	if block and block.item:
		set_cell(position, 0)
	elif not block:
		set_cells_terrain_connect([position], 0, -1)
