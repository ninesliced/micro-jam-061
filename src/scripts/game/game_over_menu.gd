extends Control


func pause():
	show()
	get_tree().paused = true


func unpause():
	hide()
	get_tree().paused = false


func _on_retry_pressed() -> void:
	TransitionManager.change_scene(load("res://src/scripts/game/game.tscn"), "square_gradient")


func _on_main_menu_pressed() -> void:
	TransitionManager.change_scene(load("res://src/main.tscn"), "square_gradient")


func _on_quit_pressed() -> void:
	get_tree().quit()
