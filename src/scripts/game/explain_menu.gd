extends Control


func _ready() -> void:
	get_tree().paused = true

func _on_retry_2_pressed() -> void:
	get_tree().paused = false
	hide()
	$"../PauseMenu".pausable = true
