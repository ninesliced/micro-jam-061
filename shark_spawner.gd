extends Node2D
class_name SharkSpawner

@export var shark_scene : PackedScene

@export var spawn_enable : bool = true
@export var min_spawn_delay : float = 5.0
@export var max_spawn_delay : float = 10.0
 
@export var spawn_radius :float = 35.0

var spawn_delay : float:
	get:
		return randf_range(min_spawn_delay, max_spawn_delay)
@export var game: Game

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
	var new_shark := shark_scene.instantiate() as Shark
	add_child(new_shark)
	new_shark.spawner = self
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, spawn_radius)
	var random_pos = Vector2.RIGHT.rotated(angle) * distance
	new_shark.position = random_pos
	
	
	
