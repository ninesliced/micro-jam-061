extends Node2D


func _on_play_pressed() -> void:
	TransitionManager.change_scene(load("res://src/scripts/game/game.tscn"), "square_gradient")



func _on_quit_pressed() -> void:
	get_tree().quit()
