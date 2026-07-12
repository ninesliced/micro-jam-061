extends Node2D

func _ready() -> void:
	get_tree().change_scene_to_file("res://src/scripts/game/game.tscn")
