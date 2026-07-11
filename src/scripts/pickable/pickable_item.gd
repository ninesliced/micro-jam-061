extends Node2D
class_name PickableItem
@export var resource: Pickable
@export var sprite_2d: Sprite2D

@export var is_moving: bool = true
@export var is_picked: bool = false
@export var moving_direction: Vector2
@export var move_speed : float = 0.1

var mat : ShaderMaterial
@export var sink_height : int = 4:
	set(v):
		sink_height = v
		set_inline_width(v)
func _ready() -> void:
	mat = sprite_2d.material as ShaderMaterial
	if is_instance_valid(resource): load_resource()
	
func _process(delta: float) -> void:
	if is_moving:
		position +=  moving_direction.normalized() * move_speed
	
func load_resource()->void:
	sprite_2d.texture = resource.sprite

func pick()-> void:
	pass
	

func hover()-> void:
	if not is_picked:
		set_outline_color(Color.WHITE)
		set_outline_width(2)
	
	
func unhover()-> void:
	if not is_picked:
		set_outline_color(Color.BLACK)
		set_outline_width(1)
	

func drop()->void:
	pass
	
func set_outline_color(color : Color)->void:
	if mat is ShaderMaterial:
		mat.set_shader_parameter("outline_color", color)

func set_outline_width(width : int)->void:
	if mat is ShaderMaterial:
		mat.set_shader_parameter("outline_width", width)

func set_inline_width(width : int)->void:
	if mat is ShaderMaterial:
		mat.set_shader_parameter("inline_width", width)
