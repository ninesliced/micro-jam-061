class_name Game
extends Node2D

@export var map: Map

var time = 0.0

var hand: Pickable = null:
	set(value):
		hand = value
		print("Hand")
		if value:
			print("Hand Value")
			%HandSprite.texture = value.sprite
		else:
			%HandSprite.texture = null
		
func can_set_hand():
	return hand == null

func set_hand(pickable: Pickable):
	hand = pickable
	print("Get pickable", pickable)

func use_hand():
	print("libere")
	hand = null
	Input.set_custom_mouse_cursor(null)

func get_hand():
	return hand

func _process(delta: float) -> void:
	time += delta
	%TimeLabel.text = "%d:%02d" % [int(time) / 60, int(fmod(time, 60.0))]

@export var game_over_menu: Control

func game_over():
	print("GAME OVER")
	game_over_menu.pause()
