extends Control
@export var image : Sprite2D

@export var grid_size : HSlider
@export var pixel_size : HSlider

@onready var shader : ShaderMaterial = image.material

var grid_sizes : Array[int] = [120, 60, 30, 15]
func _on_grid_size_value_changed(value: float) -> void:
	shader.set_shader_parameter("pixel_size", grid_sizes[value])


func _on_pixel_size_value_changed(value: float) -> void:
	shader.set_shader_parameter("pixel_size", value)
