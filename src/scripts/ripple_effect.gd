extends AnimatedSprite2D
class_name RippleEffect
var death_timer: float = 5
var is_spawn : bool = false
func on_spawn()->void:
	death_timer = 5.0
	play("ripple")
	is_spawn = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_spawn:
		death_timer -= delta
		if death_timer < 0:
			queue_free()
