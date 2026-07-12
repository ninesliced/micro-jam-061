extends Node2D
class_name Map

static var element_type: Dictionary[String, ElementResource] = {
	"Sand" = load("res://src/scripts/block/element/sand.tres"),
	"Grass" = load("res://src/scripts/block/element/grass.tres"),
	"Rock" = load("res://src/scripts/block/element/rock.tres")
}


static var item_type: Dictionary[String, ItemResource] = {
	"Seed" = load("res://src/scripts/block/item/seed.tres"),
	"Tree" = load("res://src/scripts/block/item/tree.tres"),
	"Nexus" = load("res://src/scripts/block/item/nexus.tres"),	
	"George" = load("res://src/scripts/block/item/george.tres"),	
	"Vide" = load("res://src/scripts/block/item/vide.tres"),	
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

var erosion_particles: Dictionary[Vector2i, ErosionParticles] = {}
const EROSION_PARTICLES = preload("uid://0nmm1clwb373")

func _ready() -> void:
	place_element(Vector2i(0,0), get_element_by_name("Rock"))
	place_item(Vector2i(0,0), get_item_by_name("Nexus"))


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
	if current_block != null and current_block.item and current_block.item.item_name == "Vide" and picakble:
		match picakble.type:
			Pickable.PickableType.Seed:
				place_item(pos, get_item_by_name("Seed"))
				return true
	
	# Reparer le sable
	if current_block and current_block.element.element_name == "Sand" and picakble and picakble.type == Pickable.PickableType.Sand:
		current_block.deserodate(0)
		return true
		
	# recup george
	if current_block != null and current_block.item and current_block.item.item_name == "George" and not picakble:
		current_block.set_item("Vide")
		$"..".hand = Pickable.PickableType.George
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
	update_erosion_particles(pos, block)

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

func update_erosion_particles(pos: Vector2i, block: Block):
	if block and block.element and block.element.erosion_level > 0:
		var ptc: ErosionParticles
		if not erosion_particles.has(pos):
			ptc = EROSION_PARTICLES.instantiate()
			ptc.global_position = Vector2(pos) * 16.0 + Vector2(8, 8)
			add_child(ptc)
			erosion_particles[pos] = ptc
		ptc = erosion_particles[pos]
		ptc.speed_scale = remap(block.element.erosion_level, 0.0, block.element.erosion_max, 1.0, 3.0)
		ptc.amount = int(floor(remap(block.element.erosion_level, 0.0, block.element.erosion_max, 2, 8)))
		ptc.scale_amount_min = remap(block.element.erosion_level, 0.0, block.element.erosion_max, 1.0, 3.0)
		ptc.scale_amount_max = remap(block.element.erosion_level, 0.0, block.element.erosion_max, 3.0, 8.0)
		ptc.restart()
	
	elif not block or not block.element or block.element.erosion_level <= 0:
		if erosion_particles.has(pos):
			erosion_particles[pos].queue_free()
			erosion_particles.erase(pos)

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

func global_pos_to_pos(gp: Vector2i):
	return (gp - Vector2i(-8,-8))/16
	
# Si il trouve pas de block il renvoie en -1000, -1000
func shark_at_global_pos(gp: Vector2i, shark: Shark) -> Block:
	var pos = global_pos_to_pos(gp)
	var block = get_current_block(pos)
	if not block:
		for dpos in Utils.four_directions:
			var block_next = get_current_block(pos+dpos)
			if block_next:
				block_next.add_shark(shark)
				return block_next
		for dpos in Utils.diagobal_directions:
			var block_next = get_current_block(pos+dpos)
			if block_next:
				block_next.add_shark(shark)
				return block_next
		print("Pas de block a sharker")
		return null
	block.add_shark(shark)
	return block
