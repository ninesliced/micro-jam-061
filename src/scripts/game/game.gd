extends Node2D

var hand: Pickable = null:
	set(value):
		hand = value
		if value:
			%HandSprite.texture = value.sprite
		else:
			%HandSprite.texture = null
		
func can_set_hand():
	return hand == null

func set_hand(pickable: Pickable):
	hand = pickable

func use_hand():
	hand = null
	Input.set_custom_mouse_cursor(null)

func get_hand():
	return hand
