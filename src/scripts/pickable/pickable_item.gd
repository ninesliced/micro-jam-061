extends Node2D

@export var resource: Pickable
@export var sprite_2d: Sprite2D

@export var is_moving: bool
@export var is_picked: bool = false
@export var moving_direction: Vector2
@export var move_speed : float = 50
var mat : ShaderMaterial

func _ready() -> void:
	mat = sprite_2d.material as ShaderMaterial
	if is_instance_valid(resource): load_resource()
	
func load_resource()->void:
	sprite_2d.texture = resource.sprite

func pick()-> void:
	pass
	

func hover()-> void:
	if not is_picked:
		set_outline_color(Color.WHITE)
	
	
func unhover()-> void:
	if not is_picked:
		set_outline_color(Color.BLACK)
	

func drop()->void:
	pass
	
func set_outline_color(color : Color)->void:
	if mat is ShaderMaterial:
		mat.set_shader_parameter("outline_color", color)
