extends Node
class_name Block

@export var element: Element
@export var item: Item = null

@export var map_referance: Map

func _init(map, element, item = null):
	self.map_referance = map
	self.element = element
	self.item = item

func set_element(element):
	self.element = element

func set_item(new_item):
	self.item = new_item

func _on_random_tick_item():
	if not self.item.random_state_update:
		return
	var random_f = randf()
	if random_f < self.item.random_state_update:
		if self.item == Map.item_type["Seed"]:
			self.item.current_state += 1
			if self.item.current_state > self.item.max_random_state:
				self.set_item(Map.item_type["Tree"])
			self.map_referance.a_block_was_updated()

func _on_random_tick_element():
	if not self.element.erosion_proba:
		return
	var random_f = randf()
	if random_f < self.element.erosion_proba:
		self.element.errosion_level += 1
		if self.element.erosion_level > self.element.erosion_max:
			self.map_referance.destroy_block(self)
		self.map_referance.a_block_was_updated()

func _on_random_tick():
	_on_random_tick_item()
	_on_random_tick_element()
