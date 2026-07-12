extends Node2D
class_name Map

static var element_type: Dictionary[String, ElementResource] = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Grass" = load("res://src/scripts/block/element/grass.tres")
}


static var item_type: Dictionary[String, ItemResource] = {
	"Seed" = load("res://src/scripts/block/item/seed.tres"),
	"Tree" = load("res://src/scripts/block/item/tree.tres"),
}


static func get_element_by_name(name) -> Element:
	if not name in element_type.keys():
		return null
	return Element.new(element_type[name])

static func get_item_by_name(name) -> Item:
	if not name in item_type.keys():
		return null
	return Item.new(item_type[name])

var map: Dictionary[Vector2i, Block] = {}
var top_left_corner: Vector2i = Vector2i(0,0)
var bottom_right_corner: Vector2i = Vector2i(0,0)
var max_size_map: int = 1

@onready var item_layer: TileMapLayer = $ItemLayer
@onready var element_layer: TileMapLayer = $CanvasGroup/ElementLayer
@onready var grass_layer: TileMapLayer = $CanvasGroup/GrassLayer
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	place_element(Vector2i(0,0), get_element_by_name("Sand"))


func is_element_placable(pos: Vector2i):
	# Place item
	if pos in map.keys():
		return false
	# faut check si a touche une case a cote
	for dpos in Utils.four_directions:
		if pos+dpos in map.keys():
			return true
	return false

func get_current_block(pos: Vector2i) -> Block: # Ou null
	if pos in map.keys():
		return map[pos]
	return null

# Retourne true si ca a reussi a interact
func interact_at(pos: Vector2i, picakble: Pickable) -> bool:
	# print(picakble.type, " ", Pickable.PickableType.Sand)
	# Place element
	if is_element_placable(pos) and picakble:
		match picakble.type:
			Pickable.PickableType.Sand:
				place_element(pos, get_element_by_name("Sand"))
				return true
				
	# Place item
	var current_block = get_current_block(pos)
	# Si y'a un block et que il que y'a pas d'item dessus
	if current_block != null and current_block.item == null and picakble:
		match picakble.type:
			Pickable.PickableType.Seed:
				place_item(pos, get_item_by_name("Seed"))
				return true
	return false


func place_element(pos: Vector2i, element: Element):
	self.map[pos] = Block.new(pos, self, element)
	a_block_was_updated(pos, self.map[pos])

func place_item(pos: Vector2i, item: Item):
	self.map[pos].item = item
	a_block_was_updated(pos, self.map[pos])

func destroy_block(pos: Vector2i):
	self.map.erase(pos)
	a_block_was_updated(pos, null)

func a_block_was_updated(pos: Vector2i, block: Block):
	element_layer.block_updated(pos, block)
	grass_layer.block_updated(pos, block)
	item_layer.block_updated(pos, block)
	process_size()

func process_size():
	var min_i = 1000
	var max_i = -1000
	var min_j = 1000
	var max_j = -1000
	for pos in map.keys():
		min_i = min(min_i, pos.x)
		max_i = max(max_i, pos.x)
		min_j = min(min_j, pos.y)
		max_j = max(max_j, pos.y)
	top_left_corner = Vector2i(min_i, min_j)
	bottom_right_corner = Vector2i(max_i, max_j)
	if min_i == 1000:
		max_size_map = 1
	else:
		max_size_map = max(max_i - min_i, max_j - min_j)

func play_sound(position: Vector2, audio: AudioStream):
	audio_stream_player.global_position = position
	audio_stream_player.stream = audio
	audio_stream_player.play()


var selected = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == Key.KEY_SPACE:
		selected = (selected+1) % 2
	
	if event is InputEventMouse:
		var pressed = (
			(event is InputEventMouseButton and event.is_pressed()) or 
			(event is InputEventMouseMotion and 
				(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or 
				Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT))
			)
		)
		
		if pressed:
			var pos = item_layer.to_local(get_global_mouse_position())
			var grid_pos = item_layer.local_to_map(pos)
			
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if Input.is_key_pressed(KEY_SHIFT) and OS.has_feature("debug"):
					var pickable = Pickable.new()
					var elem
					if selected == 0:
						elem = get_element_by_name("Sand")
					elif selected == 1:
						elem = get_element_by_name("Grass")
					place_element(grid_pos, elem)
				else:
					var game: Game = $".."
					var pickable = game.get_hand()
					var interact_has_worked = interact_at(grid_pos, pickable)
					if interact_has_worked:
						if pickable:
							play_sound(get_global_mouse_position(), pickable.audio)
						game.use_hand()
					
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and OS.has_feature("debug"):
				destroy_block(grid_pos)

var timer = 0

func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		timer -= 1
		
		for pos in map.keys():
			var block = map[pos]
			block._on_random_tick()
	%Debeugue.text = map_to_text()
	
func map_to_text():
	var texte = ""
	var min_i = 1000
	var max_i = -1000
	var min_j = 1000
	var max_j = -1000
	for pos in map.keys():
		min_i = min(min_i, pos.x)
		max_i = max(max_i, pos.x)
		min_j = min(min_j, pos.y)
		max_j = max(max_j, pos.y)
	for j in range(min_j, max_j+1):
		for i in range(min_i, max_i+1):
			var blok = get_current_block(Vector2i(i, j))
			if blok:
				texte += blok.element.get_value_letter()
				if blok.item:
					texte += blok.item.get_value_letter() + "|"
				else:
					texte += "  |"
			else:
				texte += "    |"
		texte += "\n"
			
	return texte
