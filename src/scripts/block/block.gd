extends Resource
class_name Block

@export var element: Element
@export var item: Item = null

func _init(element, item = null):
	self.element = element
	self.item = item

func set_element(element):
	self.element = element

func set_item(new_item):
	self.item = new_item

func on_interact(with = null):
	return
	
func _on_random_tick():
	return
