extends RigidBody2D
class_name Shark

var target : Vector2 = Vector2(0,0)
var acceleration : float = 1000
var max_speed : float = 80
var is_moving : bool = true
var angular_force = 50000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _physics_process(delta):
	if is_moving:
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
