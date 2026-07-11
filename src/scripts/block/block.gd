extends Node
class_name Block

var position: Vector2i
@export var element: Element
@export var item: Item = null

@export var map_referance: Map

func _init(pos, map, element_, item_ = null):
	self.position = pos
	self.map_referance = map
	self.element = element_
	self.item = item_

func set_element(element_):
	self.element = element_

func set_item(new_item):
	self.item = new_item
	self.item.current_state = 0
	self.element.erosion_level = 0
	if new_item == Map.item_type["Tree"]:
		if not has_water_next_to():
			set_element(Map.element_type["Grass"])

func _on_random_tick_item():
	# Si il a un voisin arbre alors il peut placer un une seed
	
	# il essaye de s'agrandire
	if not self.item.random_state_update:
		return
	var random_f = randf()
	if random_f < self.item.random_state_update:
		if self.item == Map.item_type["Seed"]:
			self.item.current_state += 1
			if self.item.current_state > self.item.max_random_state:
				self.set_item(Map.item_type["Tree"])
			self.map_referance.a_block_was_updated(self.position, self)

func _on_random_tick_element():
	if not self.element.erosion_proba:
		return
	var random_f = randf()
	if random_f < self.element.erosion_proba and can_erodate():
		self.element.erosion_level += 1
		if self.element.erosion_level > self.element.erosion_max:
			erodate_block()
		self.map_referance.a_block_was_updated(self.position, self)

func erodate_block():
	if self.element == Map.element_type["Grass"]:
		self.set_element(Map.element_type["Sand"])
	else:
		self.map_referance.destroy_block(self.position)


func has_water_next_to() -> bool:
	for dpos in Utils.four_directions:
		if not self.map_referance.get_current_block(dpos+self.position):
			return true
	return false

func can_erodate() -> bool:
	return has_water_next_to()

func _on_random_tick():
	_on_random_tick_item()
	_on_random_tick_element()

var timer = 0
func _process(delta: float) -> void:
	timer += delta
	if timer > 1:
		timer -= 1
		_on_random_tick()
	
