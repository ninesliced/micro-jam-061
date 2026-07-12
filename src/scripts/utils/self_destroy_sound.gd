extends AudioStreamPlayer2D

var timer = 1.0

func _ready() -> void:
	play()


func _process(delta: float) -> void:
	timer -= delta
	if timer < 0:
		queue_free()


func _on_finished() -> void:
	queue_free()
