extends Node2D
class_name PickableSpawner

@export var spawnable_items : Array[Pickable]
@export var possible_directions : Array[Vector2]
@export var pickable_item_scene : PackedScene

@export var spawn_enable : bool = true
@export var spawn_delay : float = 3.0
var _timer : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = spawn_delay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_enable:
		_timer -= delta
		if _timer <= 0:
			spawn_random()
			_timer = spawn_delay


func spawn_random() -> void:
	var new_item : PickableItem = pickable_item_scene.instantiate() as PickableItem
	add_child(new_item)
	new_item.moving_direction = possible_directions.pick_random()
	new_item.resource = spawnable_items.pick_random()
	new_item.load_resource()
	
	
