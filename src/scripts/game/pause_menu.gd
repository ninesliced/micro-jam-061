extends Control

@onready var resume: Button = $ColorRect/VBoxContainer/Resume
@onready var quit: Button = $ColorRect/VBoxContainer/Quit

var pausable = false

func _ready() -> void:
	resume.pressed.connect(unpause)
	quit.pressed.connect(func():
		get_tree().quit()
	)


func pause():
	if not pausable:
		return
	show()
	get_tree().paused = true


func unpause():
	hide()
	get_tree().paused = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func _on_resume_2_pressed() -> void:
	get_tree().paused = false
	TransitionManager.change_scene(load("res://src/buffer_retry.tscn"), "square_gradient")


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	TransitionManager.change_scene(load("res://src/main.tscn"), "square_gradient")
