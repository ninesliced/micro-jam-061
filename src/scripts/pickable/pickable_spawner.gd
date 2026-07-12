extends Node2D
class_name PickableSpawner

@export var spawnable_items : Array[Pickable]
@export var possible_directions : Array[Vector2]
@export var pickable_item_scene : PackedScene

@export var spawn_enable : bool = true
@export var min_spawn_delay : float = 5.0
@export var max_spawn_delay : float = 10.0
 
@export var spawn_radius :float = 35.0

@export var limit = INF
var count = 0

var spawn_delay : float:
	get:
		return randf_range(min_spawn_delay, max_spawn_delay)
@export var game: Node2D

var _timer : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = spawn_delay
	count = limit 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_enable:
		_timer -= delta
		if _timer <= 0:
			spawn_random()
			_timer = spawn_delay


func spawn_random() -> void:
	if count <= 0:
		return
	count -= 1
	var new_item : PickableItem = pickable_item_scene.instantiate() as PickableItem
	add_child(new_item)
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, spawn_radius)
	var random_pos = Vector2.RIGHT.rotated(angle) * distance
	new_item.position = random_pos
	new_item.moving_direction = possible_directions.pick_random()
	new_item.resource = spawnable_items.pick_random()
	new_item.load_resource()
	
	
