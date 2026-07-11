extends Control

@onready var resume: Button = $ColorRect/VBoxContainer/Resume
@onready var quit: Button = $ColorRect/VBoxContainer/Quit

func _ready() -> void:
	resume.pressed.connect(unpause)
	# quit.pressed.connect(func():
	#	get_tree().quit()
	# )


func pause():
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
