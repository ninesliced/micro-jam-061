extends Control

var time = 0.0

func pause():
	show()
	get_tree().paused = true
	time = $"../..".time
	$ColorRect/VBoxContainer/Label3.text = "Time: %d:%02d" % [int(time) / 60, int(fmod(time, 60.0))]

func unpause():
	hide()
	get_tree().paused = false


func _on_retry_pressed() -> void:
	get_tree().paused = false
	TransitionManager.change_scene(load("res://src/buffer_retry.tscn"), "square_gradient")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	TransitionManager.change_scene(load("res://src/main.tscn"), "square_gradient")


func _on_quit_pressed() -> void:
	get_tree().quit()
