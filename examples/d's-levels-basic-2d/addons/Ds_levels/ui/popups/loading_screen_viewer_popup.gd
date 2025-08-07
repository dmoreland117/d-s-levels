@tool
extends VBoxContainer


@onready var loading_screen_container: Control = %loading_screen_container
@onready var h_slider: HSlider = $HBoxContainer/HSlider

var data:LevelData
var loading_screen:LoadingScreen

func _ready():
	if !data:
		return
	
	var path = LoadingScreenDataStorage.get_data_by_label(data.loading_screen_name).path
	loading_screen = LoadingScreenUtils.load_from_path(path, data)
	loading_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	loading_screen_container.add_child(loading_screen)


func _on_h_slider_value_changed(value: float) -> void:
	if !loading_screen:
		return
	
	loading_screen.update_progress(value)
