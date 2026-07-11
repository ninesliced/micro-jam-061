extends Resource
class_name Block

@export var element: Element
@export var item: Item = null

func _init(material, item = null):
	self.material = material
	self.item = item
