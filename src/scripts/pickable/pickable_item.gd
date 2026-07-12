extends RigidBody2D
class_name PickableItem
@export var resource: Pickable
@export var sprite_2d: Sprite2D
@export var ripple_effect: AnimatedSprite2D

@export var is_moving: bool = true
@export var is_picked: bool = false
@export var is_floating: bool = true:
	set(v):
		is_floating = v
		set_water_inline_on(v)
		
@export var moving_direction: Vector2
var move_speed : float = 10
@export var min_move_speed : float = 7
@export var max_move_speed : float = 10

var mat : ShaderMaterial
@export var sink_height : int = 4:
	set(v):
		sink_height = v
		set_inline_width(v)
		
var _death_timer : float = 10
@export var lifespan : float = 120
		
func _ready() -> void:
	mat = sprite_2d.material as ShaderMaterial
	if is_instance_valid(resource): load_resource()
	unhover()
	_death_timer = lifespan
	
	
func _process(delta: float) -> void:
	_death_timer -= delta
	if _death_timer <= 0:
		queue_free()
		return
	#if is_moving:
		#position +=  moving_direction.normalized() * move_speed
	#
func _on_clicked() -> void:
	var cursor_img = resource.sprite.get_image().duplicate()
	cursor_img.resize(100, 100, Image.INTERPOLATE_NEAREST)
	Input.set_custom_mouse_cursor(cursor_img, Input.CURSOR_ARROW, Vector2(50, 50))
	
	get_parent().game.set_hand(resource)
	queue_free.call_deferred()
	pass
	
func load_resource()->void:
	sprite_2d.texture = resource.sprite
	move_speed = randf_range(min_move_speed, max_move_speed)
	linear_velocity = moving_direction.normalized() * move_speed
func pick()-> void:
	pass
	

func hover()-> void:
	if not is_picked:
		set_outline_color(Color.WHITE)
		set_outline_width(2)
		#is_floating = false
	
func unhover()-> void:
	if not is_picked:
		set_outline_color(Color.BLACK)
		set_outline_width(1)
		#is_floating = true

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
		
func set_water_inline_on(value : bool)->void:
	if mat is ShaderMaterial:
		mat.set_shader_parameter("use_water_inline", value)

func ripple()->void:
	if is_floating:
		ripple_effect.reparent(get_parent())
		ripple_effect.global_position = global_position
		ripple_effect.play("ripple")


func _on_body_entered(body: Node) -> void:
	ripple()
