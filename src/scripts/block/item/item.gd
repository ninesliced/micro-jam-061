extends Resource
class_name Item

@export var name: String
@export var texture: Texture2D

var current_state = 0
var water_level = 0
@export var random_state_update = null
@export var max_random_state = 15

func update_water(new_water_level):
	self.water_level = new_water_level

func update_state(new_state):
	self.current_state = new_state
