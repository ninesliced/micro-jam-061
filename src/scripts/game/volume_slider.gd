extends HSlider

@export var audio_bus_name: String = "Master"

var _bus_index: int

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index(audio_bus_name)
	min_value = 0.0
	max_value = 1.0
	step = 0.05
	var current_db = AudioServer.get_bus_volume_db(_bus_index)
	value = db_to_linear(current_db)
	value_changed.connect(_on_volume_value_changed)


func _on_volume_value_changed(new_value: float) -> void:
	var db_value = linear_to_db(new_value)
	AudioServer.set_bus_volume_db(_bus_index, db_value)
