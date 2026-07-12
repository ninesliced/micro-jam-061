extends Node2D
class_name SharkSpawner

@export var shark_scene : PackedScene

@export var spawn_enable : bool = true


@export var start_min_spawn_delay : float = 5.0
@export var start_max_spawn_delay : float = 10.0

@export var endgame_min_spawn_delay : float = 5.0
@export var endgame_max_spawn_delay : float = 10.0
 
@export var spawn_radius :float = 35.0
var elapsed_game_time : float = 0
var endgame_time : float = 180
var time_to_endgame_ratio: float:
	get:
		if elapsed_game_time >= endgame_time : return 1
		return elapsed_game_time/endgame_time

var min_spawn_delay : float:
	get:
		return start_min_spawn_delay + time_to_endgame_ratio*(endgame_min_spawn_delay- start_min_spawn_delay) 
var max_spawn_delay : float:
	get:
		return start_max_spawn_delay + time_to_endgame_ratio*(endgame_max_spawn_delay- start_max_spawn_delay) 

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
	elapsed_game_time += delta
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
	
	
	
