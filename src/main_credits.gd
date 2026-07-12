extends Label

func _ready() -> void:
	text = "A game by "
	var credits = ["ArkanYota", "Yolwoocle", "NowaLeTyrex"]
	credits.shuffle()
	
	for c in 2:
		text += credits[c] + ", "
	text += credits[2]
