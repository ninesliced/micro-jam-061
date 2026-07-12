extends RigidBody2D
class_name Shark


@onready var sprite: AnimatedSprite2D = $Sprite2D

var target : Vector2 = Vector2(0,0)
var acceleration : float = 1000
var max_speed : float = 80
var is_moving : bool = true
var angular_force = 50000
@export var tile_detector: Area2D
var spawner : SharkSpawner
var is_sharking : bool = false
var sharking_targets: Array[Block]
@export var target_sprite: Sprite2D

@export var sharking_sprite: Texture2D
@export var swimming_sprite: Texture2D
signal leave_tile
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var is_therock = false



func _physics_process(delta):
	if is_moving:
		
		sprite.play("fin")
		sprite.scale = Vector2(1, 1)
		# Calculate direction from body to target
		var direction = global_position.direction_to(target)
		var velocity : Vector2 = direction * acceleration
		var dot: float = velocity.normalized().dot(linear_velocity.normalized())
		var opposition_factor: float = remap(dot, 1.0, -1.0, 0.0, 1.0)
		var mobility_bonus: float = 5.0 * opposition_factor 
		
		velocity += velocity * mobility_bonus

		# Amortit l'accélération au-delà de la vitesse max (dans le sens du mouvement).
		if (linear_velocity.length() > max_speed) \
				and (velocity.normalized().dot(linear_velocity.normalized()) > 0.2):
			velocity -= velocity * absf(velocity.normalized().dot(linear_velocity.normalized()))
		# Apply force in that direction
		# Note: Force causes acceleration. To maintain constant speed, 
		# you may need to adjust mass or use Impulses (Method 2).
		apply_central_force(velocity)
		
		var dir = transform.y.dot(global_position.direction_to(target))
		constant_torque = dir * angular_force
	
		sprite.global_position = round(global_position)
		sprite.rotation = global_transform.inverse().get_rotation()
		if velocity.x < 0: sprite.flip_h = velocity.x < 0
	elif is_sharking:
		sprite.scale = Vector2(0.2, 0.2)
		sprite.flip_h = false
		sprite.play("eating")
		sprite.rotation = get_angle_to(sharking_targets[0].global_pos)
		target_sprite.global_position = sharking_targets[0].global_pos

func update_sharking_behavior()->void:
	if sharking_targets.is_empty():
		is_sharking = false
		is_moving = true
	else:
		is_sharking = true
		is_moving = false

func _on_tile_detector_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		if spawner.game.map:
			var target_block: Block = spawner.game.map.shark_at_global_pos(tile_detector.global_position, self)
			if target_block:
				is_sharking = true
				if not target_block.is_connected("block_erodated", block_sharked):
					target_block.connect("block_erodated", block_sharked)
				if not sharking_targets.has(target_block):
					sharking_targets.append(target_block)
			update_sharking_behavior()

func block_sharked(block : Block)->void:
	if sharking_targets.has(block):
		sharking_targets.erase(block)
	update_sharking_behavior()
func _on_tile_detector_body_exited(body: Node2D) -> void:
	leave_tile.emit(self)

func die()->void:
	leave_tile.emit(self)
	queue_free()


func _on_button_pressed() -> void:
	if spawner.game.get_hand() and spawner.game.get_hand().type == Pickable.PickableType.George:
		spawner.game.use_hand()
		die()
