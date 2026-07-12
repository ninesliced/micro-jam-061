extends Node2D

@export var hand_sprite: Texture2D
@onready var game: Game = $"../.."

func _process(delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	global_position = get_global_mouse_position()
	if game.hand:
		$HandSprite.texture = game.hand.sprite 
	else:
		$HandSprite.texture = hand_sprite 
