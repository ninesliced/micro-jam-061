extends Node
class_name Block

var position: Vector2i
@export var element: Element
@export var item: Item = null

@export var map_referance: Map

var erosion_particles: ErosionParticles
var baby_sharked = false
var sharks = []

func _init(pos, map, element_, item_ = null):
	self.position = pos
	self.map_referance = map
	self.element = element_
	self.item = item_
	# self.item.current_state = 0
	# self.element.erosion_level = 0

func set_element(element_):
	self.element = element_

func set_item(new_item):
	self.item = new_item
	self.item.current_state = 0
	self.element.erosion_level = 0
	print(item, item.item_name)
	if new_item and new_item.item_name == "Tree":
		if not has_water_next_to():
			set_element(Map.get_element_by_name("Grass"))

func _on_random_tick_item():
	# Si il a un voisin arbre alors il peut placer un une seed
	if not self.item:
		return
	# il essaye de s'agrandire
	if not self.item.random_state_update:
		return
	var random_f = randf()
	if random_f < self.item.random_state_update:
		print(random_f, self.item.random_state_update)
		if self.item.item_name == "Seed":
			self.item.current_state += 1
			print("updated", self.item.current_state)

			if self.item.current_state >= self.item.max_random_state:
				self.set_item(Map.get_item_by_name("Tree"))
			self.map_referance.a_block_was_updated(self.position, self)
		elif self.item.item_name == "Tree":
			if has_water_next_to():
				self.item.current_state += 1

				if self.item.current_state >= self.item.max_random_state:
					self.set_element(Map.get_element_by_name("Grass"))
				self.map_referance.a_block_was_updated(self.position, self)
			else:
				self.item.current_state = max(self.item.current_state -1, 0)
				self.map_referance.a_block_was_updated(self.position, self)

func _on_random_tick_element():
	if not self.element.erosion_proba:
		return
	var random_f = randf()
	if random_f < self.element.erosion_proba:
		if can_erodate():
			self.element.erosion_level += 1
			self.map_referance.a_block_was_updated(self.position, self)
			if self.element.erosion_level > self.element.erosion_max:
				erodate_block()
		elif can_deserodate():
			self.element.erosion_level = max(self.element.erosion_level - 1, 0)
			self.map_referance.a_block_was_updated(self.position, self)

func erodate_block():
	if self.element == Map.get_element_by_name("Grass"):
		self.set_element(Map.get_element_by_name("Sand"))
	else:
		self.map_referance.destroy_block(self.position)


func has_water_next_to() -> bool:
	for dpos in Utils.four_directions:
		if not self.map_referance.get_current_block(dpos+self.position):
			return true
	return false

func can_erodate() -> bool:
	return has_water_next_to() and baby_sharked

func can_deserodate() -> bool:
	return not has_water_next_to()


func _on_random_tick():
	_on_random_tick_item()
	_on_random_tick_element()

func deserodate(value = 0):
	self.element.erosion_level = 0
	self.map_referance.a_block_was_updated(self.position, self)

func get_sharked():
	baby_sharked = true
	
func get_desharked():
	baby_sharked = false
	
func add_shark(shark: Shark):
	sharks.append(shark)
	shark.connect("leave_tile", remove_shark)
	get_sharked()

func remove_shark(shark: Shark):
	sharks.erase(shark)
	if len(sharks) == 0:
		baby_sharked = false
	


func _to_string() -> String:
	return "<Block:elem=%s,item=%s>" % [element.name if element else "null", item.name if item else "null"]
