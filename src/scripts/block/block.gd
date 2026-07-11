extends Resource
class_name Block

@export var element: Element
@export var item: Item = null

func _init(material, item = null):
	self.material = material
	self.item = item

func set_material(new_material):
	self.material = new_material

func set_item(new_item):
	self.item = new_item

func on_interact(with = null):
	return
	
func _on_random_tick():
	return
