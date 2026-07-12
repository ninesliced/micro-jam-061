extends TileMapLayer

func block_updated(position: Vector2i, block: Block):
	if block and block.item and block.item.item_name != "Vide":
		set_cell(position, block.item.tileset_source_id, block.item.tileset_atlas_coord + Vector2i(block.item.current_state, 0))
	elif not block:
		erase_cell(position)
