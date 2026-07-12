extends CanvasGroup

func _process(delta):
	var scale_factor = get_viewport().get_screen_transform().get_scale().x
	material.set_shader_parameter("scale_factor", scale_factor)
