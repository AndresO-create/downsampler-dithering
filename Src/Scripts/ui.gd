extends Control
@export var image : Sprite2D

@export var grid_size : HSlider
@export var pixel_size : HSlider
@export var dropdown : MenuButton

@onready var shader : ShaderMaterial = image.material

var grid_sizes : Array[float] = [60, 30, 15, 7.5]

func _ready() -> void:
	#set default parameters
	shader.set_shader_parameter("pixel_size", grid_sizes[grid_size.value])
	shader.set_shader_parameter("radius", pixel_size.value/10)
	
	#connect dropdown signals
	dropdown.get_popup().id_pressed.connect(_on_dropdown_item_pressed)
	
func _on_grid_size_value_changed(value: float) -> void:
	shader.set_shader_parameter("pixel_size", grid_sizes[value])


func _on_radius_value_changed(value: float) -> void:
	shader.set_shader_parameter("radius", value/10)

func _on_dropdown_item_pressed(id : int) -> void:
	dropdown.get_popup().toggle_item_checked(id)
	var value : bool = dropdown.get_popup().is_item_checked(id)

	match id:
		0: shader.set_shader_parameter("lum_radius", value)
		1: shader.set_shader_parameter("palette_swap", value)


func _on_palette_item_selected(index: int) -> void:
	shader.set_shader_parameter("selected_palette", index)
